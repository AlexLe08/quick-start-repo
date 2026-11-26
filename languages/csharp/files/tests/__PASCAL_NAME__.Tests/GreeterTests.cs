namespace {{PASCAL_NAME}}.Tests;

public class GreeterTests
{
    [Fact]
    public void GreetsByName()
    {
        Assert.Equal("Hello, Alex!", Greeter.Greet("Alex"));
    }
}
