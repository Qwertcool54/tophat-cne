function postCreate() {
 for (s in 0...4) {
    var opX = cpuStrums.members[s].x;
    cpu.members[s].x =  playerStrums.members[s].x;
    player.members[s].x = opX;    

 }
}