## 运行所需环境
#### 1、下载edge-tts Python库，推荐使用annaconda，
```
pip install edge-tts
```
#### 2、将annaconda脚本库 `\Scripts` 文件目录加入系统环境变量。

#### 3、验证环境变量是否加入
若在cmd中键入 `edge-tts` 后显示：
```
usage: edge-tts [-h] [-t TEXT] [-f FILE] [-v VOICE] [-l] [--rate RATE] [--volume VOLUME] [--pitch PITCH]
                [--write-media WRITE_MEDIA] [--write-subtitles WRITE_SUBTITLES] [--proxy PROXY]
edge-tts: error: one of the arguments -t/--text -f/--file -l/--list-voices is required
```
则说明edge-tts环境已经配置好
#### 4、运行edgetts.ahk
拖入文件或文件夹，在上方编辑框输入文字并选择语音可以测试想要的
#### 5、高级设置
如果你熟悉命令行，可以设置模板预设来方便使用。