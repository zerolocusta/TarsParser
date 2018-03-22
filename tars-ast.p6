enum TarsType <
    Void,
    Bool,
    Byte,
    Short,
    Int,
    Long,
    Float,
    Double,
    String,
    UnsignedByte,
    UnsignedShort,
    UnsignedInt,
    Vector,
    Map,
>;

class ASTNode {

    method toHash() {
        self.panic("ASTNode method toHash NOT IMPLEMENT");
    }
        
    method panic($msg) {
        die "$msg found";
    }
    
}

class BaseTarsType is ASTNode {
    method toHash() {
        say("BaseTarsType method toHash NOT IMPLEMENT");
        nextsame;
    }
}

class MapTarsType is BaseTarsType {
    has BaseTarsType $!keyType;
    has BaseTarsType $!valueType;
    
    method toHash() {
        return %(
            keyType => $!keyType.toHash(),
            valueType => $!keyType.toHash(),
        );
    }
}

class VectorTarsType is BaseTarsType {
    has BaseTarsType $!valueType;
}

class ModuleNode is ASTNode {
    method toHash() { }
}

my $a = MapTarsType.new;
say $a.toHash;