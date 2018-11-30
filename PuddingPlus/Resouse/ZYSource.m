#import "ZYSource.h"
@implementation ZYSource


#pragma mark - 初始化单例 
+ (ZYSource *)getInstanse{ 
    static ZYSource * handle = nil; 
    static dispatch_once_t onceToken; 
    dispatch_once(&onceToken, ^{ 
        handle = [[ZYSource alloc] init]; 
    });
     return handle;
}
- (NSString *) about_pudding {
 return NSLocalizedString(@"about_pudding", nil);
}

- (NSString *) add_new_pudding {
 return NSLocalizedString(@"add_new_pudding", nil);
}

- (NSString *) add_pudding { 
 return NSLocalizedString(@"add_pudding", nil); 
}

- (NSString *) already_bind_tip { 
 return NSLocalizedString(@"already_bind_tip", nil); 
}

- (NSString *) already_bind_tip_contact { 
 return NSLocalizedString(@"already_bind_tip_contact", nil); 
}

- (NSString *) baby_dynamic { 
 return NSLocalizedString(@"baby_dynamic", nil); 
}

- (NSString *) big_voice_tip { 
 return NSLocalizedString(@"big_voice_tip", nil); 
}

- (NSString *) bind_scuess { 
 return NSLocalizedString(@"bind_scuess", nil); 
}

- (NSString *) buding { 
 return NSLocalizedString(@"buding", nil); 
}

- (NSString *) config_net_error_tip { 
 return NSLocalizedString(@"config_net_error_tip", nil); 
}

- (NSString *) config_net_scuess { 
 return NSLocalizedString(@"config_net_scuess", nil); 
}

- (NSString *) config_net_wait_tip { 
 return NSLocalizedString(@"config_net_wait_tip", nil); 
}

- (NSString *) connet_power { 
 return NSLocalizedString(@"connet_power", nil); 
}

- (NSString *) content_select { 
 return NSLocalizedString(@"content_select", nil); 
}

- (NSString *) funny_story { 
 return NSLocalizedString(@"funny_story", nil); 
}

- (NSString *) near_pudding { 
 return NSLocalizedString(@"near_pudding", nil); 
}

- (NSString *) night_tip { 
 return NSLocalizedString(@"night_tip", nil); 
}

- (NSString *) not_hear_tip { 
 return NSLocalizedString(@"not_hear_tip", nil); 
}

- (NSString *) not_hear_tip_say { 
 return NSLocalizedString(@"not_hear_tip_say", nil); 
}

- (NSString *) not_support_5g_net { 
 return NSLocalizedString(@"not_support_5g_net", nil); 
}

- (NSString *) open_power { 
 return NSLocalizedString(@"open_power", nil); 
}

- (NSString *) other_config_network { 
 return NSLocalizedString(@"other_config_network", nil); 
}

- (NSString *) play_pudding { 
 return NSLocalizedString(@"play_pudding", nil); 
}

- (NSString *) prepare_pudding { 
 return NSLocalizedString(@"prepare_pudding", nil); 
}

- (NSString *) pudding { 
 return NSLocalizedString(@"pudding", nil); 
}

- (NSString *) pudding_album { 
 return NSLocalizedString(@"pudding_album", nil); 
}

- (NSString *) pudding_alter_sleep { 
 return NSLocalizedString(@"pudding_alter_sleep", nil); 
}

- (NSString *) pudding_current_new { 
 return NSLocalizedString(@"pudding_current_new", nil); 
}

- (NSString *) pudding_info { 
 return NSLocalizedString(@"pudding_info", nil); 
}

- (NSString *) pudding_is_status { 
 return NSLocalizedString(@"pudding_is_status", nil); 
}

- (NSString *) pudding_new_skills { 
 return NSLocalizedString(@"pudding_new_skills", nil); 
}

- (NSString *) pudding_new_version { 
 return NSLocalizedString(@"pudding_new_version", nil); 
}

- (NSString *) pudding_offline { 
 return NSLocalizedString(@"pudding_offline", nil); 
}

- (NSString *) pudding_score { 
 return NSLocalizedString(@"pudding_score", nil); 
}

- (NSString *) pudding_setting { 
 return NSLocalizedString(@"pudding_setting", nil); 
}

- (NSString *) pudding_story_online { 
 return NSLocalizedString(@"pudding_story_online", nil); 
}

- (NSString *) pudding_system_upgrade { 
 return NSLocalizedString(@"pudding_system_upgrade", nil); 
}

- (NSString *) pudding_version { 
 return NSLocalizedString(@"pudding_version", nil); 
}

- (NSString *) pudding_version_low { 
 return NSLocalizedString(@"pudding_version_low", nil); 
}

- (NSString *) pudding_voice { 
 return NSLocalizedString(@"pudding_voice", nil); 
}

- (NSString *) remove_binding { 
 return NSLocalizedString(@"remove_binding", nil); 
}

- (NSString *) restart_pudding { 
 return NSLocalizedString(@"restart_pudding", nil); 
}

- (NSString *) say_baby_name { 
 return NSLocalizedString(@"say_baby_name", nil); 
}

- (NSString *) say_pudding { 
 return NSLocalizedString(@"say_pudding", nil); 
}

- (NSString *) send_voice { 
 return NSLocalizedString(@"send_voice", nil); 
}

- (NSString *) send_voice_scuess { 
 return NSLocalizedString(@"send_voice_scuess", nil); 
}

- (NSString *) setting_allow_system_album { 
 return NSLocalizedString(@"setting_allow_system_album", nil); 
}

- (NSString *) setup_pudding_state { 
 return NSLocalizedString(@"setup_pudding_state", nil); 
}

- (NSString *) setup_pudding_tip { 
 return NSLocalizedString(@"setup_pudding_tip", nil); 
}

- (NSString *) start_play { 
 return NSLocalizedString(@"start_play", nil); 
}

- (NSString *) teach_pudding { 
 return NSLocalizedString(@"teach_pudding", nil); 
}

- (NSString *) update_nickname { 
 return NSLocalizedString(@"update_nickname", nil); 
}

- (NSString *) voice_scuess { 
 return NSLocalizedString(@"voice_scuess", nil); 
}

- (NSString *) you_advice { 
 return NSLocalizedString(@"you_advice", nil); 
}

@end