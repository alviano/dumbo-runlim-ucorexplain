from pathlib import Path

import typer
from dumbo_asp.primitives.models import Model
from dumbo_asp.primitives.programs import SymbolicProgram
from dumbo_asp.queries import explanation_graph, pack_xasp_navigator_url
from dumbo_runlim import utils
from dumbo_runlim.utils import run_experiment, external_command
from dumbo_utils.console import console
from dumbo_utils.files import load_file
from dumbo_utils.url import compress_object_for_url
from xasp.entities import Explain

programs = {
    "ucore 4x4": load_file(__file__, "data/sudoku-4x4.ucorexplain.asp"),
    "ucore 9x9": load_file(__file__, "data/sudoku-9x9.ucorexplain.asp"),
    "xasp 4x4": load_file(__file__, "data/sudoku-4x4.xasp.asp"),
    "xasp 9x9": load_file(__file__, "data/sudoku-9x9.xasp.asp"),
}


def measure_ucore(program, answer_set, query):
    the_program = SymbolicProgram.parse(program)  # just to be fair, let's recompute everything at each iteration
    herbrand_base = the_program.herbrand_base
    graph = explanation_graph(the_program, answer_set, herbrand_base, Model.of_atoms(query))
    return graph


def teardown_ucore(query, result):
    graph = result
    links = len(graph.filter(lambda atom: atom.predicate_name == "link"))
    assumptions = graph.as_facts.count("(assumption,") - 1  # the node "None" is always flagged as assumption
    url = pack_xasp_navigator_url(graph, as_forest_with_roots=Model.of_atoms(query), with_chopped_body=True,
                                  with_backward_search=True,
                                  backward_search_symbols=(';', ' :-'))
    return links, assumptions, url


def measure_xasp(program, answer_set, queries):
    explain = Explain.the_program(
        program,
        the_answer_set=answer_set,
        the_atoms_to_explain=queries,
    )
    graph = explain.explanation_dag()
    return graph, explain


def teardown_xasp(result):
    graph, explain = result
    links = len(graph.filter(lambda atom: atom.predicate_name == "link"))
    assumptions = len(explain.minimal_assumption_set())
    explain.compute_igraph()
    url = "https://xasp-navigator.netlify.app/#" + compress_object_for_url(explain.navigator_graph())
    return links, assumptions, url


@external_command
def command(
        output_file: Path = typer.Option(
            "output.csv", "--output-file", "-o",
            help="File to store final results",
        ),
) -> None:
    answer_sets = {key: Model.of_program(program) for key, program in programs.items()}
    queries = {key: answer_set.filter(lambda atom: atom.predicate_name == "assign")
               for key, answer_set in answer_sets.items()}
    res = {}

    def on_complete_task(task_id, resources, result):
        console.log(f"Task {task_id}: {resources}, links={result[0]}, assumptions={result[1]}")
        res[task_id] = (resources, result)

    def on_all_done():
        with open(output_file, "w") as file:
            file.write(f"task_id\treal_time\ttime\tmemory\tlinks\tassumptions\turl\n")
            for task_id, (resources, result) in res.items():
                links, assumptions, url = result
                file.write(
                    f"{task_id}\t{resources.real_time_usage}\t{resources.time_usage}\t{resources.memory_usage}\t{links}\t{assumptions}\t{url}\n")
        utils.on_all_done_log()

    run_experiment(
        *(
            {
                "task_id": f"{key} {query}",
                "measure": (measure_ucore, {
                    "program": programs[key],
                    "answer_set": answer_sets[key],
                    "query": query,
                }),
                "teardown": (teardown_ucore, {
                    "query": query,
                }),
            } if "xasp" not in key else {
                "task_id": f"{key} {query}",
                "measure": (measure_xasp, {
                    "program": programs[key],
                    "answer_set": answer_sets[key],
                    "queries": Model.of_atoms(query, str(query).replace("assign", "assign'")),
                }),
                "teardown": (teardown_xasp, {
                }),

            } for key in queries.keys() for query in queries[key]
        ),
        on_complete_task=on_complete_task,
        on_all_done=on_all_done,
    )

