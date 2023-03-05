import "scripts/level/enemies/slime"
import "scripts/level/enemies/fly"
import "scripts/level/enemies/crab"
import "scripts/level/enemies/slimeMedium"
import "scripts/level/enemies/flyMedium"
import "scripts/level/enemies/crabMedium"

SpawnProbabilities = {
    {
        {4, Slime}
    },
    {
        {8, Slime},
        {1, Crab}
    },
    {
        {8, Slime},
        {4, Crab}
    },
    {
        {8, Slime},
        {8, Crab},
        {4, Fly}
    },
    {
        {4, Slime},
        {8, Crab},
        {8, Fly}
    },
    {
        {4, Slime},
        {4, Crab},
        {8, Fly},
        {4, SlimeMedium}
    },
    {
        {2, Slime},
        {4, Crab},
        {4, Fly},
        {8, SlimeMedium},
        {4, CrabMedium}
    },
    {
        {2, Slime},
        {2, Crab},
        {4, Fly},
        {8, SlimeMedium},
        {8, CrabMedium},
        {4, FlyMedium}
    },
    {
        {1, Slime},
        {2, Crab},
        {2, Fly},
        {12, SlimeMedium},
        {8, CrabMedium},
        {8, FlyMedium}
    },
    {
        {1, Slime},
        {1, Crab},
        {2, Fly},
        {12, SlimeMedium},
        {8, CrabMedium},
        {8, FlyMedium}
    },
    {
        {1, Slime},
        {1, Crab},
        {1, Fly},
        {8, SlimeMedium},
        {12, CrabMedium},
        {8, FlyMedium}
    },
    {
        {1, Slime},
        {1, Crab},
        {1, Fly},
        {8, SlimeMedium},
        {12, CrabMedium},
        {12, FlyMedium}
    },
    {
        {1, Slime},
        {1, Crab},
        {1, Fly},
        {4, SlimeMedium},
        {8, CrabMedium},
        {12, FlyMedium}
    },
    {
        {0, Slime},
        {1, Crab},
        {1, Fly},
        {4, SlimeMedium},
        {8, CrabMedium},
        {12, FlyMedium}
    },
    {
        {0, Slime},
        {0, Crab},
        {1, Fly},
        {2, SlimeMedium},
        {4, CrabMedium},
        {16, FlyMedium}
    },
    {
        {0, Slime},
        {0, Crab},
        {0, Fly},
        {2, SlimeMedium},
        {4, CrabMedium},
        {20, FlyMedium}
    },
}
