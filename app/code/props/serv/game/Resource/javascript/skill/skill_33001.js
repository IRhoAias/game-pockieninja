importPackage(com.d2.serv.game.Public);
importPackage(com.d2.serv.game.FightModule);

//���ӶԷ�30%�ķ���
function OnUse(fightsystem, self, target, skill, fv,timer)
{
    var script_m = target.Defence;
    target.Defence = target.Defence*0.7;
    var damage = GetDamage(FightObject self);
    var selfdamage = 0;
    fightsystem.Attack(self,target,damage,selfdamage,fv,timer);
    target.Defence = script_m;
    return UserSkillReturn.SKILL_SUCCESS;
}