grammar G {
     
    rule TOP {         
        ^            
            [ <statement> \s* <comment>? ]*         
        $
    }

    rule statement {         
        [             
            | <variable-declaration>             
            | <assignment>             
            | <say-function>         
        ] 
        ';'     
    }     
    
    rule comment {
        '#' <-[\n]>*
    }

    rule variable-declaration {         
        'my' <variable>    
    }

    token variable {         
        <sigil> <identifier>     
    }

    token sigil {         
        '$' | '@'     
    }     
    
    token identifier {         
        <alpha> <alnum>*     
    }     
    
    rule assignment {         
        <variable> '=' <expression>     
    }     
    
    rule expression {         
        | <term> '+' <expression>         
        | <value>         
        | <variable>     
    }     
    
    rule term {         
        | <value>         
        | <variable>     
    }

    token value {         
        <number>
    }

    token number {         
        <digit>+     
    }

    rule say-function {         
        'say' <variable>     
    }
}

class A {     
    has %!var;
         
    method variable-declaration($/) {         
        %!var{$<variable><sigil>}{$<variable><identifier>} = 'undefined';     
    }     
    
    method variable($/) {         
        $/.make(%!var{$<sigil>}{$<identifier>})     
    }     
    
    method assignment($/) {         
        %!var{$<variable><sigil>}{$<variable><identifier>} = $<expression>.ast;     
    }     
    
    method value($/) {         
        $/.make(+$<number>)     
    }     
    
    method say-function($/) {         
        say %!var{$<variable><sigil>}{$<variable><identifier>};     
    }     
    
    multi method term($/ where $/<value>) {         
        $/.make($<value>.ast)     
    }     
    
    multi method term($/ where $/<variable>) {         
        $/.make($<variable>.ast)    
    }     
    
    multi method expression($/ where $/<term>) {         
        $/.make($<term>.ast + $<expression>.ast)     
    }

    multi method expression($/ where $/<value>) {         
        $/.make(~$<value>)     
    }     
    
    multi method expression($/ where $/<variable>) {         
        $/.make(%!var{$<variable><sigil>}{$<variable><identifier>})     
    }
}