#!/usr/bin/env escript
-define(VALID_FLAGS, ["-b", "-n"]).

main(Args) ->
    {ok, {filenames, Filenames}, {flags, Flags}} = parse_args_caller(Args),
    cat(Filenames, Flags);
    %try
    %catch
        %_:_ ->
            %usage()
    %end;

main(_) ->
    usage().

parse_args_caller(Args) ->
    parse_args(Args, [], []).


parse_args([Arg|Rest], Files, Flags) ->
    %% If it is not a valid arg, assume it is a file
    case lists:member(Arg, ?VALID_FLAGS) of
        true -> parse_args(Rest, Files, [Arg | Flags]);
        false -> parse_args(Rest, [Arg | Files], Flags)
    end;
parse_args([], Files, Flags) ->
    {ok, {filenames, lists:reverse(Files)}, {flags, Flags}}.


usage() ->
    io:format("usage: cat filename\n"),
    halt(1).


cat(Filenames, Flags) ->
    case lists:member("-n", Flags) of
        true -> b_read_files(Filenames);
        false -> read_files(Filenames)
    end.

b_read_files([]) ->
    ok;
b_read_files([Filename|Others]) ->
    {ok, IoDevice} = file:open(Filename, [read]),
    b_print_line(IoDevice, 1),
    b_read_files(Others).

read_files([]) ->
    ok;
read_files([Filename|Others]) ->
    {ok, IoDevice} = file:open(Filename, [read]),
    print_line(IoDevice),
    read_files(Others).

b_print_line(IoDevice, LineNumber) ->
    case file:read_line(IoDevice) of
        {ok, Line} ->
            io:format("     ~B~c~s", [LineNumber, 9, Line]),
            b_print_line(IoDevice, LineNumber + 1);
        eof ->
            done
    end.

print_line(IoDevice) ->
    case file:read_line(IoDevice) of
        {ok, Line} ->
            io:format("~s", [Line]),
            print_line(IoDevice);
        eof ->
            done
    end.

