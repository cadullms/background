using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using client_app.Models;
using Dapr.Client;

namespace client_app.Controllers
{
    public class ProcessingController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly DaprClient _daprClient;

        public ProcessingController(ILogger<HomeController> logger, DaprClient daprClient)
        {
            _logger = logger;
            _daprClient = daprClient;
        }

        public IActionResult Index()
        {
            var newModel = new MessageModel();
            return View(newModel);
        }

        [HttpPost]
        public async Task<IActionResult> Index(MessageModel model)
        {
            _logger.LogInformation($"Got message {model.Message}.");
            try
            {
                await _daprClient.InvokeBindingAsync("processing-queue", "create", model.Message);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error while trying to send message to queue via dapr binding: {ex.Message} {ex.InnerException?.Message}");
            }

            var newModel = new MessageModel();
            return View(newModel);
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
