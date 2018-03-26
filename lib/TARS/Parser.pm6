use TARS::AST;
no precompilation;
use Grammar::Tracer;
grammar Tars {
    rule TOP {
        [
            | <comment>
            | <module-definition>
        ]+
    }

    rule module-definition {
        <module> <name> '{' 
            [
                |   <enumerate-definition>
                |   <struct-definition>
                |   <interface-definition>
            ]*
        '}' ';'
    }

    rule struct-definition {
        <struct> <name> '{' 
            [
                | <struct-field-definition-and-assignment>
                | <struct-field-definition>
            ]+
        '}' ';' 
    }

    rule interface-definition {
        <interface> <name> '{'
            <interface-field-definition>*
        '}' ';'
    }

    rule interface-field-definition {
        <tars-type> <name> '(' <parameter-list>? ')' ';'
    }

    rule parameter {
        <out>? <tars-type> <name>
    }

    rule parameter-list {
        [ <parameter> ',' ]* <parameter>
    }

    token out {
        'out'
    }

    rule enumerate-definition {
        <enumerate> <name> '{' 
            <enumerate-field-definition-with-comma>+
            <enumerate-field-definition-without-comma>?
        '}' ';'
    }

    rule enumerate-field-definition-with-comma {
        <name> [ '=' <number> ]? ','
    }

    rule enumerate-field-definition-without-comma {
        <name> [ '=' <number> ]? ','?
    }

    rule struct-field-definition-and-assignment {
        <tag> <field-rule> <tars-type> <name> '=' <expression> ';'
    }

    rule struct-field-definition {
        <tag> <field-rule> <tars-type> <name> ';'
    }

    rule expression {
        | <string>
        | <number>
    }

    token string {
        '"' ['\\'. | .]*? '"'
    }

    rule comment {
        # 形如 // hello wrold
        <slash><slash>\s*?[<comment-body>] 
    }
    
    proto token field-rule {
        *
    }

    token field-rule:sym<require> {
        <sym>
    }

    token field-rule:sym<optional> {
        <sym>
    }
    # struct key word
    token struct {
        'struct'
    }

    token module {
        'module'
    }

    token interface {
        'interface'
    }

    token enumerate {
        'enum'
    }

    token comment-body {
        <-[\n]>*
    }

    token slash {
        '/'
    }

    token number {
        <digit>+
    }

    token tag {
        <digit>+
    }

    token name {
        [ <alpha> | '_' ] [ <alnum> | '_' | '-' ]*
    }
    
    rule tars-type {
        | <complex-type>
        | <simple-type>
        | <struct-type>
    }

    token struct-type {
        # looks like ModuleName::StructName OR StructName only
        | <name>'::'<name>
        | <name>
    }

    proto token complex-type {
        *
    }

    token complex-type:sym<vector> {
        <sym> '<' <.ws> <tars-type> <.ws> '>'
    }

    token complex-type:sym<map> {
        <sym> '<' <.ws> <tars-type> <.ws> ',' <.ws> <tars-type> <.ws> '>'
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
    
    method panic($/, $msg) {
        my $c = $/.CURSOR;
        my $pos := $c.pos;
        say $c.gist;
        die "$msg found at pos $pos";
    }
}


class TarsAction {
    has %!ast;
    has %!currentModule;

    method comment-body($/) {
    }

    multi method tars-type($/ where $/<complex-type>) {
        $/.make($/<complex-type>.made);
    }

    multi method tars-type($/ where $/<simple-type>) {
        $/.make($/<simple-type>.made);
    }

    multi method tars-type($/ where $/<struct-type>) {
        # $/.make($/<struct-type>.made);
    }
    method complex-type:sym<map> ($/) {
        my $node = MapTarsType.new(
            keyType => $/<tars-type>[0].made,
            valueType => $/<tars-type>[1].made,
        );
        $/.make($node);
    }

    method simple-type:sym<void> ($/) {
    }

    method simple-type:sym<bool> ($/) {
    }

    method simple-type:sym<int> ($/) {
        $/.make(
            IntTarsType.new
        )
    }
}