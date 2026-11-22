% candidate_solution(?Solution)
% Solution is a fully filled-in assignment, before any clue is applied:
% four p(Name, Dept, Lang, Project) terms in the fixed order
% Alex, Ben, Carla, Dana. The departments, languages and projects are each
% a permutation of their four values, so every value of every attribute
% is used exactly once. On backtracking it enumerates all
% 4! * 4! * 4! = 13824 assignments, each exactly once.
candidate_solution([p('Alex',  DeptA, LangA, ProjA),
                    p('Ben',   DeptB, LangB, ProjB),
                    p('Carla', DeptC, LangC, ProjC),
                    p('Dana',  DeptD, LangD, ProjD)]) :-
    permutation([research, development, design, testing],
                [DeptA, DeptB, DeptC, DeptD]),
    permutation([python, java, 'c++', javascript],
                [LangA, LangB, LangC, LangD]),
    permutation(['AI', web, embedded, data],
                [ProjA, ProjB, ProjC, ProjD]).

% CLUE 1: The friend who prefers the AI project does not work in research
% and is not Dana.
% Succeeds when the (unique) person whose project is 'AI' has a department
% other than research and is not 'Dana'; fails otherwise.
clue(1, Solution) :-
    member(p(Name, Dept, _Lang, 'AI'), Solution),
    Dept \== research,
    Name \== 'Dana'.

    % CLUE 2: Alex does not work in development and does not prefer C++.
% Alex is always the first element of Solution, so his term is selected
% from the head of the list; succeeds when his department is not
% development and his language is not 'c++', fails otherwise.
clue(2, [p('Alex', Dept, Lang, _Project) | _Others]) :-
    Dept \== development,
    Lang \== 'c++'.

    % CLUE 3: The friend working in the testing department likes Python.
% Succeeds when the (unique) person whose department is testing has
% python as their language; fails otherwise.
clue(3, Solution) :-
    member(p(_Name, testing, python, _Project), Solution).

    % CLUE 4: Ben prefers web projects and does not work in testing.
% Ben is always the second element of Solution; succeeds when his
% project is web and his department is not testing, fails otherwise.
clue(4, [_Alex, p('Ben', Dept, _Lang, web) | _Others]) :-
    Dept \== testing.

    % CLUE 5: The friend whose favorite language is Java works in the design
% department.
% Succeeds when the (unique) person whose language is java has design as
% their department; fails otherwise.
clue(5, Solution) :-
    member(p(_Name, design, java, _Project), Solution).

% CLUE 6: Carla's project preference is not embedded, and her department
% is not development.
% Carla is always the third element of Solution; succeeds when her project
% is not embedded and her department is not development, fails otherwise.
clue(6, [_Alex, _Ben, p('Carla', Dept, _Lang, Project) | _Others]) :-
    Project \== embedded,
    Dept \== development.

% CLUE 7: Dana's favorite language is not Java, and she works in research
% or testing.
% Dana is always the fourth element of Solution; succeeds when her language
% is not java and her department is research or testing, fails otherwise.
clue(7, [_Alex, _Ben, _Carla, p('Dana', Dept, Lang, _Project)]) :-
    Lang \== java,
    memberchk(Dept, [research, testing]).

    % CLUE 8: The friend who prefers data projects works in research and does
% not use JavaScript.
% Succeeds when the (unique) person whose project is data has research as
% their department and a language other than javascript; fails otherwise.
clue(8, Solution) :-
    member(p(_Name, research, Lang, data), Solution),
    Lang \== javascript.

% count_solutions(+Active, -N)
% N is the number of candidate assignments for which every clue whose
% number appears in Active holds; clues not in Active are ignored.
% An empty Active list imposes no clue, so every candidate is counted.
count_solutions(Active, N) :-
    aggregate_all(count,
                  ( candidate_solution(Solution),
                    forall(member(C, Active), clue(C, Solution)) ),
                  N).