classdef audioProcessingApp_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                  matlab.ui.Figure
        UIAxes                    matlab.ui.control.UIAxes
        UIAxes2                   matlab.ui.control.UIAxes
        AudioRecorderSwitchLabel  matlab.ui.control.Label
        AudioRecorderSwitch       matlab.ui.control.Switch
        Lamp                      matlab.ui.control.Lamp
        UIAxes4                   matlab.ui.control.UIAxes
        UIAxes5                   matlab.ui.control.UIAxes
        FilterSwitchLabel         matlab.ui.control.Label
        FilterSwitch              matlab.ui.control.Switch
        Lamp_2                    matlab.ui.control.Lamp
        Switch                    matlab.ui.control.RockerSwitch
        OriginaudioLampLabel      matlab.ui.control.Label
        OriginaudioLamp           matlab.ui.control.Lamp
        AfteraudioLampLabel       matlab.ui.control.Label
        AfteraudioLamp            matlab.ui.control.Lamp
    end

    
    properties (Access = private)
        recObj % 录音数据
        myRecording %录制语音的时域序列
        myRecording1 %录制语音的频谱函数
        h_rec %FIR滤波器时域序列
        h_rec1 %FIR滤波器频谱函数
        out %滤波处理后时域序列
        out1 %滤波处理后频谱函数
        x = (1:40000)/8000 %语音信号横坐标（0~5s）
        y = (-20000:19999)/2.5 %中心化后的频谱横坐标（-8000~8000）
    end
    

    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            %理想低通的冲激响应hdn
            N = 40000;
            wc = 0.4*pi;%滤波器截止频率设置为3200Hz
            n=(0:N-1);
            r = (N-1)/2;
            hdn = sin(wc*(n-r))/pi./(n-r);
            if rem(N,2)~=0
                hdn(r+1) = wc/pi;
            end
            %矩形窗
            w_rec=rectwin(N);
            app.h_rec=hdn.*w_rec';
            %对加窗后序列进行DFT
            app.h_rec1 = fft(app.h_rec,N);
        end

        % Value changed function: AudioRecorderSwitch
        function AudioRecorderSwitchValueChanged(app, event)
            %如果录音按钮处于打开状态，则录音5s，之后指示灯会变亮
            if strcmp(app.AudioRecorderSwitch.Value, 'On') 
                %采样频率8000Hz，每次采样使用8bit编码，单声道
                app.recObj = audiorecorder(8000,8,1);
                %录制时间为5s
                recordblocking(app.recObj, 5);
                %指示灯点亮
                app.Lamp.Color = [0 1 0] ;
            else
                %若录音按钮处于关闭状态，则绘制所录制语音的时域及频域图像
                %将所录制语音数据转换为矩阵向量
                app.myRecording = getaudiodata(app.recObj);
                plot(app.UIAxes,app.x,app.myRecording);
                xlim(app.UIAxes,[0 5]);
                ylim(app.UIAxes,[-0.2 0.2]);
                %对时域数据进行DFT以得到频域图像
                app.myRecording1 = fft(app.myRecording)';
                %使用fftshift()函数使得频谱图中心化显示
                plot(app.UIAxes4,app.y,fftshift(app.myRecording1));
                xlim(app.UIAxes4,[-8000 8000]);
                ylim(app.UIAxes4,[-70 70]);
                %指示灯关闭
                app.Lamp.Color = [0.5 0.5 0.5] ;
            end

        end

        % Value changed function: FilterSwitch
        function FilterSwitchValueChanged(app, event)
            %将原始语音数据的频域与滤波器相乘进行滤波处理
            app.out1 = app.myRecording1 .* app.h_rec1;
            app.out = fliplr(ifftshift(ifft(app.out1)));
            %若按钮状态为open，则绘制滤波后信号时域及频域图像
            if strcmp(app.FilterSwitch.Value, 'On')
                plot(app.UIAxes2,app.x,app.out);
                xlim(app.UIAxes2,[0 5]);
                ylim(app.UIAxes2,[-0.2 0.2]);
                app.UIAxes2.Title.String = '滤波后信号（时域）';
                plot(app.UIAxes5,app.y,-fftshift(app.out1));
                xlim(app.UIAxes5,[-8000 8000]);
                ylim(app.UIAxes5,[-70 70]);
                app.UIAxes5.Title.String = '滤波后信号（频域）';
                %开启信号灯
                app.Lamp_2.Color = [0 1 0] ;
            else
                %若按钮状态为close，则绘制使用窗函数设计的FIR滤波器时域及频域图像
                plot(app.UIAxes2,app.x,app.h_rec);
                xlim(app.UIAxes2,[2.49 2.51]);
                ylim(app.UIAxes2,[-0.1 0.5]);
                app.UIAxes2.Title.String = 'Filter(时域）';
                plot(app.UIAxes5,app.y,abs(fftshift(app.h_rec1)));
                xlim(app.UIAxes5,[-8000 8000]);
                ylim(app.UIAxes5,[-0.1 1.1]);
                app.UIAxes5.Title.String = 'Filter(频域）';
                %关闭信号灯
                app.Lamp_2.Color = [0.5 0.5 0.5] ;
            end

        end

        % Value changed function: Switch
        function SwitchValueChanged(app, event)
            %若按钮上边被按下，则播放原始录制语音
            if strcmp(app.Switch.Value, 'On')
                sound(abs(app.myRecording),8000)
                %点亮上方信号灯并关闭下方信号灯
                app.OriginaudioLamp.Color = [0 1 0] ;
                app.AfteraudioLamp.Color = [0.5 0.5 0.5] ;
            else
                %播放滤波处理后的语音
                sound(abs(app.out),8000);
                %点亮下方信号灯并关闭上方信号灯
                app.AfteraudioLamp.Color = [0 1 0] ;
                app.OriginaudioLamp.Color = [0.5 0.5 0.5] ;
            end
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 950 579];
            app.UIFigure.Name = 'UI Figure';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, '语音信号（时域）')
            xlabel(app.UIAxes, 'T(s)')
            ylabel(app.UIAxes, 'Y')
            app.UIAxes.PlotBoxAspectRatio = [1 0.514285714285714 0.514285714285714];
            app.UIAxes.TitleFontWeight = 'bold';
            app.UIAxes.Position = [15 337 416 222];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, '滤波后信号（时域）')
            xlabel(app.UIAxes2, 'T(s)')
            ylabel(app.UIAxes2, 'Y')
            app.UIAxes2.PlotBoxAspectRatio = [1 0.514285714285714 0.514285714285714];
            app.UIAxes2.TitleFontWeight = 'bold';
            app.UIAxes2.Position = [438 343 380 208];

            % Create AudioRecorderSwitchLabel
            app.AudioRecorderSwitchLabel = uilabel(app.UIFigure);
            app.AudioRecorderSwitchLabel.HorizontalAlignment = 'center';
            app.AudioRecorderSwitchLabel.Position = [180 279 86 22];
            app.AudioRecorderSwitchLabel.Text = 'AudioRecorder';

            % Create AudioRecorderSwitch
            app.AudioRecorderSwitch = uiswitch(app.UIFigure, 'slider');
            app.AudioRecorderSwitch.ValueChangedFcn = createCallbackFcn(app, @AudioRecorderSwitchValueChanged, true);
            app.AudioRecorderSwitch.Position = [201 299 45 20];

            % Create Lamp
            app.Lamp = uilamp(app.UIFigure);
            app.Lamp.Position = [286 292 20 20];
            app.Lamp.Color = [0.502 0.502 0.502];

            % Create UIAxes4
            app.UIAxes4 = uiaxes(app.UIFigure);
            title(app.UIAxes4, '语音信号（频域）')
            xlabel(app.UIAxes4, 'F(Hz)')
            ylabel(app.UIAxes4, 'Y')
            app.UIAxes4.PlotBoxAspectRatio = [1 0.514285714285714 0.514285714285714];
            app.UIAxes4.TitleFontWeight = 'bold';
            app.UIAxes4.Position = [33 15 398 232];

            % Create UIAxes5
            app.UIAxes5 = uiaxes(app.UIFigure);
            title(app.UIAxes5, '滤波后信号（频域）')
            xlabel(app.UIAxes5, 'F(Hz)')
            ylabel(app.UIAxes5, 'Y')
            app.UIAxes5.PlotBoxAspectRatio = [1 0.514285714285714 0.514285714285714];
            app.UIAxes5.TitleFontWeight = 'bold';
            app.UIAxes5.Position = [430 15 388 241];

            % Create FilterSwitchLabel
            app.FilterSwitchLabel = uilabel(app.UIFigure);
            app.FilterSwitchLabel.HorizontalAlignment = 'center';
            app.FilterSwitchLabel.Position = [609 279 32 22];
            app.FilterSwitchLabel.Text = 'Filter';

            % Create FilterSwitch
            app.FilterSwitch = uiswitch(app.UIFigure, 'slider');
            app.FilterSwitch.ValueChangedFcn = createCallbackFcn(app, @FilterSwitchValueChanged, true);
            app.FilterSwitch.Position = [602 299 45 20];

            % Create Lamp_2
            app.Lamp_2 = uilamp(app.UIFigure);
            app.Lamp_2.Position = [702 292 20 20];
            app.Lamp_2.Color = [0.502 0.502 0.502];

            % Create Switch
            app.Switch = uiswitch(app.UIFigure, 'rocker');
            app.Switch.ValueChangedFcn = createCallbackFcn(app, @SwitchValueChanged, true);
            app.Switch.Position = [874 274 20 45];

            % Create OriginaudioLampLabel
            app.OriginaudioLampLabel = uilabel(app.UIFigure);
            app.OriginaudioLampLabel.HorizontalAlignment = 'right';
            app.OriginaudioLampLabel.Position = [845 388 70 22];
            app.OriginaudioLampLabel.Text = 'Origin audio';

            % Create OriginaudioLamp
            app.OriginaudioLamp = uilamp(app.UIFigure);
            app.OriginaudioLamp.Position = [873 367 20 20];
            app.OriginaudioLamp.Color = [0.502 0.502 0.502];

            % Create AfteraudioLampLabel
            app.AfteraudioLampLabel = uilabel(app.UIFigure);
            app.AfteraudioLampLabel.HorizontalAlignment = 'right';
            app.AfteraudioLampLabel.Position = [852 171 63 22];
            app.AfteraudioLampLabel.Text = 'After audio';

            % Create AfteraudioLamp
            app.AfteraudioLamp = uilamp(app.UIFigure);
            app.AfteraudioLamp.Position = [873 192 20 20];
            app.AfteraudioLamp.Color = [0.502 0.502 0.502];
        end
    end

    methods (Access = public)

        % Construct app
        function app = audioProcessingApp_exported

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end