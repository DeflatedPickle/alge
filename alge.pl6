my $program = q:to/END/;
; Sets a to 6
a = 6
; Sets b to 4.5
4b = 18
; Sets c to 10
0.5c = 5
END

my %vars{Str} of Num;

grammar Grammar {
    rule TOP {
        (<comment> | <variable-declaration>)*
    }

    rule comment {
        ';' \N*
    }

    rule variable-declaration {
        <name> '=' <number>+
    }

    token name {
        <number>* <letter>
    }

    token letter {
        <[a..z]>
    }

    token number {
        <[0..9]>+ ('.' <[0..9]>*)?
    }
}

class Actions {
    method variable-declaration($/) {
        if ($/<name><number> == ()) {
            %vars{$/<name><letter>.Str} = $/<number>.join.Num;
        }
        else {
            %vars{$/<name><letter>.Str} = $/<number>.join.Num / $/<name><number>.join.Num;
        }
    }
}

say Grammar.parse($program, actions => Actions.new);
say "-----";
say %vars;
