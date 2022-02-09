using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace queue_processor_app.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class MessageController : ControllerBase
    {
        private readonly ILogger<MessageController> _logger;

        public MessageController(ILogger<MessageController> logger)
        {
            _logger = logger;
        }

        [HttpPost("/processing-queue-binding")]
        public async Task Post(dynamic message)
        {
            _logger.LogInformation($"Got message '{message}' from binding 'processing-queue-binding'");
            var random = new Random();
            // simulate processing time
            await Task.Delay(random.Next(1000, 5000));
        }
    }
}
