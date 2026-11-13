using System.Runtime.InteropServices;
using Azure.Messaging.ServiceBus;

// Settings from the environment variables of the Container App (4.6.1)
var connectionString = Environment.GetEnvironmentVariable("ServiceBusConnection")
    ?? throw new InvalidOperationException("Environment variable ServiceBusConnection is not set.");
var queueName = Environment.GetEnvironmentVariable("QueueName") ?? "sbq-processed";

await using var client = new ServiceBusClient(connectionString);
await using var processor = client.CreateProcessor(queueName);

// Write every message to the console, so it shows up in the logs (4.6.2).
// The processor completes the message automatically when this handler succeeds.
processor.ProcessMessageAsync += args =>
{
    Console.WriteLine($"Received message {args.Message.MessageId}: {args.Message.Body}");
    return Task.CompletedTask;
};

processor.ProcessErrorAsync += args =>
{
    Console.Error.WriteLine($"Error from {args.ErrorSource}: {args.Exception.Message}");
    return Task.CompletedTask;
};

// Stop cleanly when the Container App scales in (SIGTERM) or on Ctrl+C locally (SIGINT)
using var shutdown = new CancellationTokenSource();
using var onSigterm = PosixSignalRegistration.Create(PosixSignal.SIGTERM, context => { context.Cancel = true; shutdown.Cancel(); });
using var onSigint = PosixSignalRegistration.Create(PosixSignal.SIGINT, context => { context.Cancel = true; shutdown.Cancel(); });

await processor.StartProcessingAsync();
Console.WriteLine($"Listening for messages on queue {queueName}...");

try
{
    await Task.Delay(Timeout.Infinite, shutdown.Token);
}
catch (TaskCanceledException)
{
    // Shutdown requested
}

await processor.StopProcessingAsync();
Console.WriteLine("Stopped.");
