#!/usr/bin/env escript
main(Args) ->
    io:format("~s", [cat(Args)]);
    %try
    %catch
        %_:_ ->
            %usage()
    %end;

main(_) ->
    usage().

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

