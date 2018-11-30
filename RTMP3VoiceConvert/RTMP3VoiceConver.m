//
//  RTMP3VoiceConver.m
//  AFNetworking
//
//  Created by baxiang on 2017/11/21.
//

#import "RTMP3VoiceConver.h"
#import "lame.h"
@implementation RTMP3VoiceConver
+ (NSString *)audioToMP3: (NSString *)sourcePath isDeleteSourchFile:(BOOL)isDelete
{
    if(sourcePath.length < 1) return nil;
    // 输入路径
    NSString *inPath = sourcePath;
    
    // 判断输入路径是否存在
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:sourcePath])
    {
        NSLog(@"文件不存在");
        return nil;
    }
    
    // 输出路径
    NSString *outPath = [[sourcePath stringByDeletingPathExtension] stringByAppendingString:@".mp3"];
    
    @try {
        int read,write;
        //只读方式打开被转换音频文件
        FILE *pcm = fopen([inPath cStringUsingEncoding:1], "rb");
        fseek(pcm, 4 * 1024, SEEK_CUR);//删除头，否则在前一秒钟会有杂音
        //只写方式打开生成的MP3文件
        FILE *mp3 = fopen([outPath cStringUsingEncoding:1], "wb");
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE * 2];
        unsigned char mp3_buffer[MP3_SIZE];
        //这里要注意，lame的配置要跟AVAudioRecorder的配置一致，否则会造成转换不成功
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 44100.0);//采样率
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            //以二进制形式读取文件中的数据
            read = (int)fread(pcm_buffer, 2 * sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            //二进制形式写数据到文件中  mp3_buffer：数据输出到文件的缓冲区首地址  write：一个数据块的字节数  1:指定一次输出数据块的个数   mp3:文件指针
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
        
    } @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    } @finally {
        NSLog(@"MP3生成成功!!!");
        if (isDelete) {
            NSError *error;
            [fm removeItemAtPath:sourcePath error:&error];
            if (error == nil)
            {
                NSLog(@"删除源文件成功");
            }
            
        }
        return outPath;
    }
    
}
@end
