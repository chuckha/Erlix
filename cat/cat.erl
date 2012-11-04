#!/usr/bin/env escript
main(Args) ->
    {ok, {filenames, Filenames}, {args, Arguments}} = parse_args_caller(Args),
    Arguments,
    cat(Filenames);
    %try
    %catch
        %_:_ ->
            %usage()
    %end;

main(_) ->
    usage().

parse_args_caller(Args) ->
    parse_args(Args, [], []).

parse_args(["-b"|Rest], Files, Args) ->
    parse_args(Rest, Files, ['-b' | Args]);
parse_args([File|Rest], Files, Args) ->
    parse_args(Rest, [File | Files], Args);
parse_args([], Files, Args) ->
    {ok, {filenames, lists:reverse(Files)}, {args, Args}}.

usage() ->
    io:format("usage: cat filename\n"),
    halt(1).

cat([]) ->
    ok;
cat([Filename|Others]) ->
    {ok, IoDevice} = file:open(Filename, [read]),
    line_by_line(IoDevice),
    cat(Others).

line_by_line(IoDevice) ->
    case file:read_line(IoDevice) of
        {ok, Line} ->
            io:format("~s", [Line]),
            line_by_line(IoDevice);
        eof ->
            done
    end.

