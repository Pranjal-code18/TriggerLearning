public class UserTriggerHandler {
    public static void afterInsert(List<User> userLists) {
        addUserToAdminGroup(userLists);
    }
    private static void addUserToAdminGroup(List<User> userLists) {
    Group publicGroup = [SELECT Id FROM Group WHERE DeveloperName = 'Admins'];
        Profile profileName = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        List<GroupMember> groupMembers = new List<GroupMember>();
        if(publicGroup != NULL) {
            for(User user : userLists) {
                if(user.IsActive == TRUE && user.ProfileId == profileName.Id) {
                    GroupMember groupMember = new GroupMember();
                    groupMember.groupId = publicGroup.Id;
                    groupMember.UserOrGroupId = user.Id;
                    groupMembers.add(groupMember);
                }
            }
        }
        if(!groupMembers.isEmpty()) {
            insert groupMembers;
        }
    }
}