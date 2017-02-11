<?php

require('db.php');
mysqli_set_charset($con,'utf8');
$deletions = [];
$additions = [];
$role_changes = [];
$realm_changes = [];

$submitted_names = [];
$submitted_roles = [];
$submitted_realms = [];
$current_names = [];

for ($i = 1; $i <= 30; $i++) {
    $n = ucfirst(strtolower(mb_substr(str_replace(['(',')',';',' '],'',$_POST["name_" . $i]),0,12)));
    array_push($submitted_names,$n);
    $ro = mb_substr(str_replace(['(',')',';'],'',$_POST["role_" . $i]),0,7);
    array_push($submitted_roles,$ro);
    $re = ucfirst(strtolower(mb_substr(str_replace(['(',')',';'],'',$_POST["realm_" . $i]),0,30)));
    array_push($submitted_realms,$re);
};

$guild_id = mysqli_fetch_row(mysqli_query($con,"SELECT guild_id from guilds WHERE key_code = '" . $_POST['keycode'] ."'"))[0];

$result = mysqli_query($con,"SELECT * FROM users WHERE guild_id = " . $guild_id . " ORDER BY name ASC");
$count = 0;

while($row = mysqli_fetch_array($result))
{
$count = $count + 1;
array_push($current_names,$row['name']);
if(!in_array($row['name'],$submitted_names)){
      array_push($deletions,$row['name']); } else {

if (!($submitted_roles[$count-1] == $row['role'])) { array_push($role_changes,[$row['name'],$submitted_roles[$count-1]]);  };
if (!($submitted_realms[$count-1] == $row['realm'])) { array_push($realm_changes,[$row['name'],$submitted_realms[$count-1]]); };
};
};

for ($i = 0; $i <= 29; $i++) {
    if(strlen($submitted_names[$i]) > 0 && strlen($submitted_roles[$i]) > 0) {
    if(!in_array($submitted_names[$i],$current_names)){
      array_push($additions,[$submitted_names[$i],$submitted_roles[$i],$submitted_realms[$i]]);
}
}
}

foreach ($deletions as &$deletion) {
    $result = mysqli_query($con,"DELETE FROM users WHERE name = '" . $deletion . "' AND guild_id = " . $guild_id);
};

foreach ($additions as &$addition) {
    $result = mysqli_query($con,"INSERT IGNORE INTO users (name,guild_id,role,realm) VALUES ('" . $addition[0] . "', " . $guild_id . ", '" . $addition[1] . "', '" . str_replace("'","\'",ucfirst($addition[2])) ."')");
};

foreach ($role_changes as &$role_change) {
    $result = mysqli_query($con,"UPDATE users SET role = '" . $role_change[1] . "' WHERE guild_id = " . $guild_id . " AND name = '" . $role_change[0] . "'");
};

foreach ($realm_changes as &$realm_change) {
    $result = mysqli_query($con,"UPDATE users SET realm = '" . str_replace("'","\'",ucfirst($realm_change[1])) . "' WHERE guild_id = " . $guild_id . " AND name = '" . $realm_change[0] . "'");
};


header("Location: manage.php?key=" . $_POST['keycode']);
die();


?>
