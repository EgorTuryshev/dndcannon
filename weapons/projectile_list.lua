 --- forts API ---
dofile("scripts/type.lua")
dofile(path .. "/globals.lua")

local howitzer = FindProjectile("howitzer")

if howitzer then  
    local function createShell(i, config)
        local newShell = DeepCopy(howitzer)
        newShell.SaveName = "shell" .. i
        newShell.ProjectileDamage = newShell.ProjectileDamage * config.modificator
        newShell.AntiAirHitpoints = newShell.AntiAirHitpoints * config.antiAirHpMod
        newShell.Impact = newShell.Impact * config.modificator
        newShell.ProjectileSplashDamage = newShell.ProjectileSplashDamage * config.modificator
        newShell.ProjectileSplashDamageMaxRadius = newShell.ProjectileSplashDamageMaxRadius * config.modificator
        newShell.ProjectileSprite = path .. "/weapons/sprites/shell" .. i .. ".png"
        newShell.ProjectileThickness = 10.0
        newShell.ProjectileShootDownRadius = 60
        newShell.DndProjectile = true
        newShell.CollidesWithLike = false
        newShell.DestroyShields = config.shield.DestroyShields
        newShell.DeflectedByShields = config.shield.DeflectedByShields
        if config.shield.DeflectedByShields then
            newShell.MomentumThreshold =
            {
                ["armour"] = { Reflect = 1000000, Penetrate = 4000 },
                ["door"] = { Reflect = 1000000, Penetrate = 4000 },
            }
        end
        Projectiles[#Projectiles + 1] = newShell
    end

    for _, config in ipairs(ProjectileConfigs) do
        for i = config.range[1], config.range[2] do
            createShell(i, config)
        end
    end
    
    local shell20 = DeepCopy(howitzer)
    shell20.SaveName = "shell20"
    shell20.ProjectileDamage = 750
    shell20.AntiAirHitpoints = 110
    shell20.Impact = 500000
    shell20.ProjectileSprite = path.. "/weapons/sprites/shell20.png"
    shell20.ProjectileThickness = 10.0
    shell20.ProjectileShootDownRadius = 60
    shell20.DndProjectile = true
    shell20.CollidesWithLike = false
    Projectiles[#Projectiles+1] = shell20

    local fireball = DeepCopy(howitzer)
    fireball.SaveName = "fireball"
    fireball.ProjectileDamage = 750
    fireball.AntiAirHitpoints = 110
    fireball.Impact = 500000
    fireball.ProjectileSprite = path.. "/weapons/sprites/fireball.png"
    fireball.ProjectileThickness = 10.0
    fireball.ProjectileShootDownRadius = 60
    fireball.ProjectileIncendiary = true
    fireball.IncendiaryRadius = 700
    fireball.AlwaysIncendiary = true
    fireball.DndProjectile = true
    fireball.CollidesWithLike = false
	fireball.TrailEffect = path.. "/effects/dice_trail.lua"
    Projectiles[#Projectiles+1] = fireball
end

local unluckMarker = DeepCopy(FindProjectile("ol_marker_sweep"))
if unluckMarker then
	unluckMarker.SaveName = "unluckMarker"
    unluckMarker.DndProjectile = true
    unluckMarker.CollidesWithLike = false -- fix needed
    unluckMarker.Projectile =
	{
		Root =
		{
			Name = "Root",
			Angle = 0,
			Sprite = path.. "/weapons/sprites/shell20.png",
			PivotOffset = {0, 0},
			Scale = 2.5,
		}
	}
    unluckMarker.Effects =
	{
		Impact =
		{
			["default"] = path .. "/effects/marker_land.lua",
		},
		Deflect =
		{
			["default"] = "effects/bullet_bracing_hit.lua",
		},
	}
	unluckMarker.dlc2_orbital = nil
	Projectiles[#Projectiles+1] = unluckMarker
end

for i, v in ipairs(Projectiles) do
    if v.DndProjectile then
       local nocol = DeepCopy(v)
       nocol.SaveName = v.SaveName .. "_nocol"
       nocol.CollidesWithProjectiles = false
       nocol.ProjectileIncendiary = false
       nocol.AlwaysPassDevices = true
       nocol.WeaponDamageBonus = 0
       nocol.EMPDuration = 0
       nocol.ProjectileDamage = 0
       nocol.DndProjectile = false
       if not nocol.DamageMultiplier then nocol.DamageMultiplier = {} end
       if not nocol.Effects then nocol.Effects = {} end
       if not nocol.Effects.Impact then nocol.Effects.Impact = {} end
       nocol.DamageMultiplier[#nocol.DamageMultiplier + 1] = { SaveName = "weapon", Direct = 0 }
       nocol.Effects.Impact.device = {
           Effect = nil,
           Terminate = false,
           Splash = false
       }
       nocol.Effects.Age = { ["t500"] = { Projectile = { Count = 1, Type = v.SaveName }, Splash = false } }
       Projectiles[#Projectiles+1] = nocol
   end
end    


local EffectShellFire = DeepCopy(FindProjectile("shrapnel"))
EffectShellFire.SaveName = "EffectShellFire"
EffectShellFire.ProjectileDamage = 0
EffectShellFire.Impact = 0
EffectShellFire.DndProjectile = false
EffectShellFire.ProjectileIncendiary = true
EffectShellFire.IncendiaryRadius = 70
EffectShellFire.IncendiaryRadiusHeated = 140
EffectShellFire.AlwaysIncendiary = true
Projectiles[#Projectiles+1] = EffectShellFire

local EffectShellSmoke = DeepCopy(FindProjectile("smokebomb"))
EffectShellSmoke.SaveName = "EffectShellSmoke"
EffectShellSmoke.ProjectileDamage = 0
EffectShellSmoke.DndProjectile = false
EffectShellSmoke.MaxAge = 15
Projectiles[#Projectiles+1] = EffectShellSmoke

local EffectShellEMP = DeepCopy(FindProjectile("shrapnel"))
EffectShellEMP.SaveName = "EffectShellEMP"
EffectShellEMP.ProjectileDamage = 0
EffectShellEMP.DndProjectile = false
EffectShellEMP.EMPRadius = 150
EffectShellEMP.EMPDuration = 10
Projectiles[#Projectiles+1] = EffectShellEMP


if moonshot then
	local EffectShellMagnet = DeepCopy(FindProjectile("magneticfield"))
	EffectShellMagnet.SaveName = "EffectShellMagnet"
    EffectShellMagnet.FieldRadius = 200.0
    EffectShellMagnet.MagneticModifierFriendly = 0
    EffectShellMagnet.MagneticModifierEnemy = 0.5
    EffectShellMagnet.FieldIntersectionNearest = false
    EffectShellMagnet.FieldStrengthMax = 500
    EffectShellMagnet.FieldStrengthFalloffPower = 0.5
    EffectShellMagnet.FieldType = 2
	EffectShellMagnet.MaxAge = 4
	EffectShellMagnet.Gravity = 0
	Projectiles[#Projectiles+1] = EffectShellMagnet
end

local unluckShell = DeepCopy(FindProjectile("howitzer"))
if unluckShell then
	unluckShell.SaveName = "unluckShell"
	unluckShell.ProjectileDamage = 100
	unluckShell.ProjectileSplashDamage = 90
	unluckShell.ProjectileSplashDamageMaxRadius = 130
	unluckShell.Gravity = unluckShell.Gravity * 1.35
	unluckShell.AntiAirHitpoints = 11
    unluckShell.DamageMultiplier = {}
    unluckShell.CollidesWithLike = false
    unluckShell.Projectile =
	{
		Root =
		{
			Name = "Root",
			Angle = 0,
			Scale = 4,
			Sprite = path .. "/weapons/sprites/shell1.png",
		}
	}
	Projectiles[#Projectiles+1] = unluckShell
end

table.insert(Projectiles, myNewProjectile)