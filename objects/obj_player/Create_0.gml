// ======================
// GLOBAL HEALTH INIT 
// ======================
if (!variable_global_exists("player_health"))
{
    global.player_health = {
        max: 5,
        current: 5,
        frame_full: 0,
        frame_empty: 8,
        segments: array_create(5, 0),
        frames: array_create(5, 0)
    };

    for (var i = 0; i < global.player_health.max; i++)
    {
        global.player_health.frames[i] = global.player_health.frame_full;
    }
}


// ===============
// HEALTH SYNC
// ===============
function player_health_sync_aliases()
{
    max_hp = global.player_health.max;
    hp = global.player_health.current;
    hp_display = global.player_health.current;
    hp_prev = global.player_health.current;

    hp_segments = global.player_health.segments;
    hp_frames = global.player_health.frames;
}


// =========================
// APPROACH 
// =========================
function player_health_approach(_cur, _tgt, _amt)
{
    if (_cur < _tgt) return min(_cur + _amt, _tgt);
    if (_cur > _tgt) return max(_cur - _amt, _tgt);
    return _cur;
}


// =================
// RESIZE BUFFER 
// =================
function player_health_resize_buffers(_new_max)
{
    var hp = global.player_health;

    var old_segments = hp.segments;
    var old_frames = hp.frames;

    hp.max = max(1, floor(_new_max));
    hp.segments = array_create(hp.max, 0);
    hp.frames = array_create(hp.max, 0);

    var keep = min(array_length(old_segments), hp.max);

    for (var i = 0; i < keep; i++)
    {
        hp.segments[i] = old_segments[i];
    }

    var keep2 = min(array_length(old_frames), hp.max);

    for (var j = 0; j < keep2; j++)
    {
        hp.frames[j] = old_frames[j];
    }

    hp.current = clamp(hp.current, 0, hp.max);
}


// ============
// DAMAGE
// ============
function player_health_apply_damage(_amount)
{
    var hp = global.player_health;
    var amount = max(0, floor(_amount));
    var dealt = 0;

    repeat (amount)
    {
        if (hp.current <= 0) break;

        hp.current -= 1;
        dealt += 1;

        if (hp.current >= 0 && hp.current < hp.max)
        {
            hp.segments[hp.current] = 1;
        }
    }

    hp.current = clamp(hp.current, 0, hp.max);
    player_health_sync_aliases();

    return dealt;
}


// ===========
// HEAL
// ===========
function player_health_heal(_amount)
{
    var hp = global.player_health;
    var amount = max(0, floor(_amount));
    var healed = 0;

    repeat (amount)
    {
        if (hp.current >= hp.max) break;

        if (hp.current >= 0 && hp.current < hp.max)
        {
            hp.segments[hp.current] = 0;
        }

        hp.current += 1;
        healed += 1;
    }

    hp.current = clamp(hp.current, 0, hp.max);
    player_health_sync_aliases();

    return healed;
}


// ================
// INCREASE MAX HP
// ================
function player_health_increase_max(_amount)
{
    var hp = global.player_health;
    var amount = max(0, floor(_amount));

    var old_max = hp.max;

    player_health_resize_buffers(old_max + amount);

    hp.current = clamp(hp.current, 0, hp.max);

    for (var i = old_max; i < hp.max; i++)
    {
        hp.segments[i] = 0;
        hp.frames[i] = hp.frame_empty;
    }

    player_health_sync_aliases();

    return amount;
}


// ================
// VISUAL UPDATE
// ================
function player_health_update_visuals()
{
    var hp = global.player_health;
    var anim_spd = 0.4;

    for (var i = 0; i < hp.max; i++)
    {
        if (hp.segments[i] > 0 && hp.segments[i] < hp.frame_empty)
        {
            hp.segments[i] += 0.25;
        }

        var target;

        if (i < hp.current)
        {
            target = hp.frame_full;
            hp.segments[i] = 0;
        }
        else
        {
            target = clamp(hp.segments[i], 0, hp.frame_empty);
        }

        hp.frames[i] = player_health_approach(hp.frames[i], target, anim_spd);
    }

    player_health_sync_aliases();
}


// =============
// WRAPPERS
// =============
take_damage = function(amount)
{
    return player_health_apply_damage(amount);
};

heal_hp = function(amount)
{
    return player_health_heal(amount);
};

increase_max_hp = function(amount)
{
    return player_health_increase_max(amount);
};