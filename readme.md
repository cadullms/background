This is loosely based on the [background worker sample for container apps](https://docs.microsoft.com/en-us/azure/container-apps/background-processing).

For demo purposes we add a load test as well to make this thing scale using the [Azure Load Testing](https://docs.microsoft.com/en-us/azure/load-testing/) service.


todo:
1. create storage queue +
1. client app that puts message into queue via dapr +
1. deploy as container app +
1. worker app that picks up message via dapr and simulates some processing +
1. deploy as container app +
1. create load test for this +
1. deploy load test to azure +