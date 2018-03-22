grammar Tars {
    rule TOP {
        [
            | <comment>
            | <simple-type>
            | <module-definition>
        ]+
    }

    rule module-definition {
        <module> <name> '{' '}' ';'
    }

    rule comment {
        # 形如 // hello wrold
        <slash><slash>\s*?[<comment-body>] 
    }

    token module {
        'module'
    }

    token comment-body {
        <-[\n]>*
    }

    token slash {
        '/'
    }
    
    token vector {
        'vector'
    }

    token map {
        'map'
    }

    token name {
        [ <alpha> | '_' ] [ <alnum> | '_' | '-' ]*
    }

    proto token simple-type {
        *
    }

    token simple-type:sym<void> {
        <sym>
    }

    token simple-type:sym<bool> {
        <sym>
    }

    token simple-type:sym<byte> {
        <sym>
    }

    token simple-type:sym<short> {
        <sym>
    }

    token simple-type:sym<int> {
        <sym>
    }

    token simple-type:sym<long> {
        <sym>
    }

    token simple-type:sym<float> {
        <sym>
    }

    token simple-type:sym<double> {
        <sym>
    }

    token simple-type:sym<string> {
        <sym>
    }

    token simple-type:sym<unsigned byte> {
        <sym>
    }

    token simple-type:sym<unsigned short> {
        <sym>
    }

    token simple-type:sym<unsigned int> {
        <sym>
    }
}


class TarsAction {
    has $!tree;

    method comment-body($/) {
        say $/.Str;
    }

    method simple-type:sym<void> ($/) {
        say 'found sym void';
    }

    method simple-type:sym<bool> ($/) {
        say 'found sym bool';
    }
}

my $result = Tars.parsefile('test.tars', actions => TarsAction.new );
say $result;