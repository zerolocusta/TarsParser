# enum TarsType <
#     Void,
#     Bool,
#     Byte,
#     Short,
#     Int,
#     Long,
#     Float,
#     Double,
#     String,
#     UnsignedByte,
#     UnsignedShort,
#     UnsignedInt,
#     Vector,
#     Map,
# >;

class ASTNode {

    method toHash() {
        self.panic("method toHash() NOT IMPLEMENT");
    }
        
    method panic($msg) {
        die "$msg found";
    }
    
}

class TarsType is ASTNode {
    has Str $.type;
    
    method toHash() {
        say("method toHash() NOT IMPLEMENT");
        nextsame;
    }
}

class MapTarsType is TarsType {
    has TarsType $.keyType is required;
    has TarsType $.valueType is required;

    method toHash() {
        return %(
            type => 'map',
            keyType => $.keyType.toHash(),
            valueType => $.keyType.toHash(),
        );
    }
}

class VectorTarsType is TarsType {
    has TarsType $.valueType;

}

class IntTarsType is TarsType {
    has Int $.value;

    method toHash() {
        return %(
            type => 'int',
            value => %.value eq {} ?? Any !! %.value
        )
    }
    
}

class ModuleNode is ASTNode {
    method toHash() { }
}