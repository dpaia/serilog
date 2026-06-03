using System.Reflection;
using Xunit;

namespace Serilog.Tests.Formatting.Json;

public class JsonFormatterTestsMethodCount
{
    [Fact]
    public void TestCountMethods()
    {
        var flags = BindingFlags.Public | BindingFlags.Instance | BindingFlags.DeclaredOnly;
        var methods = typeof(JsonFormatterTests).GetMethods(flags);
        Assert.Equal(23, methods.Length);
    }
}
