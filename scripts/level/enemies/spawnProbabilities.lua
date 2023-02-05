import "scripts/level/enemies/slime"
import "scripts/level/enemies/fly"
import "scripts/level/enemies/crab"
import "scripts/level/enemies/slimeMedium"
import "scripts/level/enemies/flyMedium"
import "scripts/level/enemies/crabMedium"

SpawnProbabilities = {
    {
        {1, Slime}
    },
    {
        {0.5, Slime},
        {0.5, Crab}
    },
    {
        {0.4, Slime},
        {0.3, Crab},
        {0.3, Fly}
    },
    {
        {0.2, Slime},
        {0.4, Crab},
        {0.4, Fly}
    },
    {
        {0.2, Slime},
        {0.4, Crab},
        {0.4, Fly}
    },
    {
        {0.2, Slime},
        {0.3, Crab},
        {0.3, Fly},
        {0.2, SlimeMedium}
    },
    {
        {0.3, Crab},
        {0.3, Fly},
        {0.2, SlimeMedium},
        {0.2, CrabMedium}
    },
    {
        {0.3, Fly},
        {0.3, SlimeMedium},
        {0.2, CrabMedium},
        {0.2, FlyMedium}
    },
    {
        {0.4, SlimeMedium},
        {0.3, CrabMedium},
        {0.3, FlyMedium}
    },
}
