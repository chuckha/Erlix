#!/usr/bin/env escript
-define(VALID_FLAGS, ["-b", "-n"]).

main(Args) ->
    {ok, {filenames, Filenames}, {flags, Flags}} = parse_args_caller(Args),
    cat(Filenames, Flags);

main(_) ->
    usage().

parse_args_caller(Args) ->
    parse_args(Args, [], []).


parse_args([Arg|Rest], Files, Flags) ->
    %% If it is not a valid arg, assume it is a file
    case lists:member(Arg, ?VALID_FLAGS) of
        true -> 
            parse_args(Rest, Files, [Arg | Flags]);
        false -> 
            parse_args(Rest, [Arg | Files], Flags)
    end;
parse_args([], Files, Flags) ->
    {ok, {filenames, lists:reverse(Files)}, {flags, Flags}}.


usage() ->
    io:format("usage: cat filename\n"),
    halt(1).


cat(Filenames, Flags) ->
    {ok, {files, Files}} = read_files(Filenames, []),
    print_files(Files, Flags).

read_files([], Files) ->
    {ok, {files, lists:reverse(Files)}};
read_files([Filename|Others], Files) ->
    {ok, IoDevice} = file:open(Filename, [read]),
    {ok, {lines, Lines}} = gather_lines(IoDevice, []),
    read_files(Others, [Lines|Files]).

gather_lines(IoDevice, Lines) ->
    case file:read_line(IoDevice) of
        {ok, Line} ->
            gather_lines(IoDevice, [Line|Lines]);
        eof ->
            {ok, {lines, lists:reverse(Lines)}}
    end.

print_files([], _) ->
    ok;
print_files([File|Files], Flags) ->
    print_lines(File, Flags, 1),
    print_files(Files, Flags).

print_lines([], _, _) ->
    ok;
print_lines([Line|Lines], Flags, LineCount) ->
    case lists:member("-n", Flags) of
        true -> 
            print_n_line(Line, LineCount);
        false ->
            print_line(Line)
    end,
    print_lines(Lines, Flags, LineCount + 1).

print_line(Line) ->
    io:format("~s", [Line]).

print_n_line(Line, LineNumber) ->
    io:format("     ~B~c~s", [LineNumber, 9, Line]).
