using System.Text.Json;
using System.Text.Json.Nodes;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace FunctionApp;

public class AddTimestamp(ILogger<AddTimestamp> logger)
{
    // Picks up a message from sbq-received, adds the current timestamp
    // and sends the result to sbq-processed (4.5.2).
    [Function(nameof(AddTimestamp))]
    [ServiceBusOutput("sbq-processed", Connection = "ServiceBusConnection")]
    public string Run(
        [ServiceBusTrigger("sbq-received", Connection = "ServiceBusConnection")] string message)
    {
        JsonObject body;
        try
        {
            body = JsonNode.Parse(message) as JsonObject ?? new JsonObject { ["message"] = message };
        }
        catch (JsonException)
        {
            // Not JSON: wrap the plain text
            body = new JsonObject { ["message"] = message };
        }

        body["timestamp"] = DateTime.UtcNow.ToString("o");

        logger.LogInformation("Forwarding message to sbq-processed: {Body}", body.ToJsonString());
        return body.ToJsonString();
    }
}
