using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using MimeTypes;

namespace Company.Function
{
    public static class HttpSPA
    {
        [FunctionName("HttpSPA")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "spa/{*restOfPath}")] HttpRequest request,
            string restOfPath,
            ILogger log,
            ExecutionContext context)
        {
            var appDirectory = context.FunctionAppDirectory;

            if (Path.HasExtension(restOfPath))
            {
                log.LogInformation($"File {restOfPath} requested.");

                var filePath = Path.Combine(appDirectory, "spa", restOfPath);
                if (File.Exists(filePath))
                {
                    return StaticFile(appDirectory, filePath);
                }

                return new NotFoundResult();
            }

            log.LogInformation($"Path {restOfPath} redirected to index.html.");
            return StaticFile(appDirectory, "spa/index.html");
        }

        private static FileStreamResult StaticFile(string appDirectory, string filePath)
        {
            var mimeType = MimeTypeMap.GetMimeType(Path.GetExtension(filePath));
            return new FileStreamResult(File.OpenRead(Path.Combine(appDirectory, filePath)), mimeType);
        }
    }
}
