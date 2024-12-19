function InitAIPLua(team)
    AIPUtil.print(team, "Starting Lua Conditions for Cerberi AIP VSR_c6_0");
end

-- BUILD PLAN CONDITIONS.

function BuildScavengerCondition(team, time)
    if (DoesRecyclerExist(team, time) == false) then
        return false, "I don't have a Recycler yet.";
    end

    if (ScavengerCount(team, time) >= 4) then
        return false, "I already have enough Scavengers.";
    end

    if (AIPUtil.GetScrap(team, false) < 20) then
        return false, "I don't have enough scrap for a Scavenger.";
    end

    return true, "My Recycler is healthy, and I need more Scavengers. Tasking Recycler to build a Scavenger.";
end

function BuildConstructorCondition(team, time)
    if (DoesRecyclerExist(team, time) == false) then
        return false, "I don't have a Recycler yet.";
    end

    if (ExtractorCount(team, time) <= 0) then
        return false, "I don't have any deployed Scavengers yet.";
    end

    if (ConstructorCount(team, time) >= 3) then
        return false, "I already have enough Constructors.";
    end

    if (AIPUtil.GetScrap(team, false) < 40) then
        return false, "I don't have enough scrap for a Constructor.";
    end

    return true, "My Recycler is healthy, I have an Extractor, and I need more Constructors. Tasking Recycler to build a Constructor.";
end

function BuildPowerLoopCondition(team, time)
    if (DoesConstructorExist(team, time) == false) then
        return false, "I don't have a Constructor yet.";
    end

    if (AIPUtil.GetPower(team, false) > 0) then
        return false, "I already have enough Power.";
    end

    if (AIPUtil.GetScrap(team, false) < 30) then
        return false, "I don't have enough scrap for a Power Plant.";
    end

    return true, "I need some power. Attempting to task a Constructor to build...";
end

function BuildFactoryCondition(team, time)
    if (DoesConstructorExist(team, time) == false) then
        return false, "I don't have a Constructor yet.";
    end

    if (AIPUtil.GetPower(team, false) <= 0) then
        return false, "I don't have enough Power for a Factory.";
    end

    if (AIPUtil.GetScrap(team, false) < 55) then
        return false, "I don't have enough scrap for a Factory.";
    end

    return true, "I can build a Factory. Attempting to task a Constructor to build...";
end

function BuildRelayCondition(team, time)
    if (DoesConstructorExist(team, time) == false) then
        return false, "I don't have a Constructor yet.";
    end

    if (AIPUtil.GetPower(team, false) <= 0) then
        return false, "I don't have enough Power for a Relay Bunker.";
    end

    if (DoesFactoryExist(team, time) == false) then
        return false, "I don't have a Factory yet. Build a Factory first.";
    end

    if (AIPUtil.GetScrap(team, false) < 50) then
        return false, "I don't have enough scrap for a Relay Bunker.";
    end

    return true, "I can build a Relay Bunker. Attempting to task a Constructor to build...";
end

function BuildArmoryCondition(team, time)
    if (DoesConstructorExist(team, time) == false) then
        return false, "I don't have a Constructor yet.";
    end

    if (AIPUtil.GetPower(team, false) <= 0) then
        return false, "I don't have enough Power for an Armory.";
    end

    if (DoesFactoryExist(team, time) == false) then
        return false, "I don't have a Factory yet. Build a Factory first.";
    end

    if (AIPUtil.GetScrap(team, false) < 60) then
        return false, "I don't have enough scrap for an Armory.";
    end
end

function BuildTurretsCondition(team, time)
    -- Make sure we have a pool first.
    if (ExtractorCount(team, time) <= 0) then
        return false, "I don't have any deployed Scavengers yet.";
    end

    -- Make sure we also have a Constructor as that's our priority.
    if (DoesConstructorExist(team, time) == false) then
        return false, "I don't have a Constructor yet.";
    end

    if (AIPUtil.GetScrap(team, false) < 40) then
        return false, "I don't have enough scrap for a turret.";
    end

    -- Do this until we build an armory.
    if (DoesArmoryExist(team, time)) then
        return false, "I have an armory, so I'm not going to waste scrap on turrets.";
    end

    return true, "Building turrets for early map control.";
end

function BuildMineLayersCondition(team, time)
    -- Make sure we have a pool first.
    if (ExtractorCount(team, time) <= 0) then
        return false, "I don't have any deployed Scavengers yet.";
    end

    if (DoesFactoryExist(team, time) == false) then
        return false, "I don't have a Factory yet. Build a Factory first.";
    end

    if (AIPUtil.GetScrap(team, false) < 55) then
        return false, "I don't have enough scrap for a Minelayer.";
    end

    return true, "I can build a Minelayer. Attempting to task the Factory to build...";
end

function UpgradePoolCondition(team, time)
    if (DoesConstructorExist(team, time) == false) then
        return false, "I don't have a Constructor yet.";
    end

    if (ExtractorCount(team, time) <= 0) then
        return false, "I don't have any deployed Scavengers yet.";
    end

    if (AIPUtil.GetScrap(team, false) < 60) then
        return false, "I don't have enough scrap to upgrade an Extractor.";
    end

    return true, "I have an Extractor that can be upgraded. Tasking Constructor to upgrade an Extractor.";
end

function CollectPoolCondition(team, time)
    if (ScavengerCount(team, time) <= 0) then
        return false, "I don't have any Scavengers.";
    end

    if (DoesScrapPoolExist(team, time) == false) then
        return false, "I cannot find any available scrap pools.";
    end

    return true, "Tasking a Scavenger to collect a pool.";
end

function CollectFieldCondition(team, time)
    if (ScavengerCount(team, time) > 0 and DoesLooseScrapExist(team, time)) then
        return true, "Tasking a Scavenger to collect loose.";
    else
        return false, "No loose or Scavenger is available. Cannot collect loose yet.";
    end
end

-- ATTACKER PLAN CONDITIONS.

function EarlyScoutAttackCondition(team, time)
    -- Make sure we have a pool first.
    if (ExtractorCount(team, time) <= 0) then
        return false, "I don't have any deployed Scavengers yet.";
    end

    if (DoesFactoryExist(team, time)) then
        return false, "I have a Factory already, I don't want to send Scouts to attack now.";
    end

    return true, "I am going to send early Scouts to attack.";
end

function EarlyTankAttackCondition(team, time)
    -- Make sure we have a pool first.
    if (ExtractorCount(team, time) <= 0) then
        return false, "I don't have any deployed Scavengers yet.";
    end

    if (DoesFactoryExist(team, time) == false) then
        return false, "I don't have a Factory so I can't attack.";
    end

    return true, "I am going to send Tanks to attack.";
end

-- COUNT FUNCTIONS TO CHECK IF A NUMBER OF GAME OBJECT EXISTS.

function ScavengerCount(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_SCAVENGER", "sameteam", true);
end

function ExtractorCount(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR", "sameteam", true);
end

function ConstructorCount(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_CONSTRUCTIONRIG", "sameteam", true);
end

-- BOOLEAN FUNCTIONS TO CHECK IF A SINGULAR GAME OBJECT EXISTS.

function DoesLooseScrapExist(team, time)
    return AIPUtil.CountUnits(team, "resource", "friendly", true) > 0;
end

function DoesScrapPoolExist(team, time)
    return AIPUtil.CountUnits(team, "biometal", "friendly", true) > 0;
end

function DoesRecyclerExist(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_RECYCLERBUILDING", "sameteam", true) > 0;
end

function DoesFactoryExist(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_FACTORY", "sameteam", true) > 0;
end

function DoesArmoryExist(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_ARMORY", "sameteam", true) > 0;
end

function DoesConstructorExist(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_CONSTRUCTIONRIG", "sameteam", true) > 0;
end