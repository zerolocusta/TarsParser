grammar Tars {
    rule TOP {
        [
            | <comment>
            | <type>
        ]+
    }

    rule comment {
        # 形如 // hello wrold
        <slash><slash>\s*?[<comment-body>] 
    }

    token comment-body {
        <-[\n]>*
    }

    token slash {
        '/'
    }

    proto token type {
        *
    }

    token type:sym<void> {
        <sym>
    }

    token type:sym<bool> {
        <sym>
    }

    token type:sym<byte> {
        <sym>
    }

    token type:sym<short> {
        <sym>
    }
}


class TarsAction {
    has $!tree;

    method comment-body($/) {
        say $/.Str;
    }

    method type:sym<void> ($/) {
        say 'found sym void';
    }

    method type:sym<bool> ($/) {
        say 'found sym bool';
    }
}

my $result = Tars.parsefile('test.tars', actions => TarsAction.new );
say $result;