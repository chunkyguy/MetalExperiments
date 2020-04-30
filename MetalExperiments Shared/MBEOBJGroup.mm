#import "MBEOBJGroup.h"
#import "WLTypes.h"

@implementation MBEOBJGroup

- (instancetype)initWithName:(NSString *)name
{
    if ((self = [super init]))
    {
        _name = [name copy];
    }
    return self;
}

- (NSString *)description
{
    size_t vertCount = self.vertexData.length / sizeof(WLVertex);
    size_t indexCount = self.indexData.length / sizeof(WLInt16);
    return [NSString stringWithFormat:@"<MBEOBJMesh %p> (\"%@\", %d vertices, %d indices)",
            self, self.name, (int)vertCount, (int)indexCount];
}

@end


