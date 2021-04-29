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
        recObj % ¼������
        myRecording %¼��������ʱ������
        myRecording1 %¼��������Ƶ�׺���
        h_rec %FIR�˲���ʱ������
        h_rec1 %FIR�˲���Ƶ�׺���
        out %�˲������ʱ������
        out1 %�˲������Ƶ�׺���
        x = (1:40000)/8000 %�����źź����꣨0~5s��
        y = (-20000:19999)/2.5 %���Ļ����Ƶ�׺����꣨-8000~8000��
    end
    

    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            %�����ͨ�ĳ弤��Ӧhdn
            N = 40000;
            wc = 0.4*pi;%�˲�����ֹƵ������Ϊ3200Hz
            n=(0:N-1);
            r = (N-1)/2;
            hdn = sin(wc*(n-r))/pi./(n-r);
            if rem(N,2)~=0
                hdn(r+1) = wc/pi;
            end
            %���δ�
            w_rec=rectwin(N);
            app.h_rec=hdn.*w_rec';
            %�ԼӴ������н���DFT
            app.h_rec1 = fft(app.h_rec,N);
        end

        % Value changed function: AudioRecorderSwitch
        function AudioRecorderSwitchValueChanged(app, event)
            %���¼����ť���ڴ�״̬����¼��5s��֮��ָʾ�ƻ����
            if strcmp(app.AudioRecorderSwitch.Value, 'On') 
                %����Ƶ��8000Hz��ÿ�β���ʹ��8bit���룬������
                app.recObj = audiorecorder(8000,8,1);
                %¼��ʱ��Ϊ5s
                recordblocking(app.recObj, 5);
                %ָʾ�Ƶ���
                app.Lamp.Color = [0 1 0] ;
            else
                %��¼����ť���ڹر�״̬���������¼��������ʱ��Ƶ��ͼ��
                %����¼����������ת��Ϊ��������
                app.myRecording = getaudiodata(app.recObj);
                plot(app.UIAxes,app.x,app.myRecording);
                xlim(app.UIAxes,[0 5]);
                ylim(app.UIAxes,[-0.2 0.2]);
                %��ʱ�����ݽ���DFT�Եõ�Ƶ��ͼ��
                app.myRecording1 = fft(app.myRecording)';
                %ʹ��fftshift()����ʹ��Ƶ��ͼ���Ļ���ʾ
                plot(app.UIAxes4,app.y,fftshift(app.myRecording1));
                xlim(app.UIAxes4,[-8000 8000]);
                ylim(app.UIAxes4,[-70 70]);
                %ָʾ�ƹر�
                app.Lamp.Color = [0.5 0.5 0.5] ;
            end

        end

        % Value changed function: FilterSwitch
        function FilterSwitchValueChanged(app, event)
            %��ԭʼ�������ݵ�Ƶ�����˲�����˽����˲�����
            app.out1 = app.myRecording1 .* app.h_rec1;
            app.out = fliplr(ifftshift(ifft(app.out1)));
            %����ť״̬Ϊopen��������˲����ź�ʱ��Ƶ��ͼ��
            if strcmp(app.FilterSwitch.Value, 'On')
                plot(app.UIAxes2,app.x,app.out);
                xlim(app.UIAxes2,[0 5]);
                ylim(app.UIAxes2,[-0.2 0.2]);
                app.UIAxes2.Title.String = '�˲����źţ�ʱ��';
                plot(app.UIAxes5,app.y,-fftshift(app.out1));
                xlim(app.UIAxes5,[-8000 8000]);
                ylim(app.UIAxes5,[-70 70]);
                app.UIAxes5.Title.String = '�˲����źţ�Ƶ��';
                %�����źŵ�
                app.Lamp_2.Color = [0 1 0] ;
            else
                %����ť״̬Ϊclose�������ʹ�ô�������Ƶ�FIR�˲���ʱ��Ƶ��ͼ��
                plot(app.UIAxes2,app.x,app.h_rec);
                xlim(app.UIAxes2,[2.49 2.51]);
                ylim(app.UIAxes2,[-0.1 0.5]);
                app.UIAxes2.Title.String = 'Filter(ʱ��';
                plot(app.UIAxes5,app.y,abs(fftshift(app.h_rec1)));
                xlim(app.UIAxes5,[-8000 8000]);
                ylim(app.UIAxes5,[-0.1 1.1]);
                app.UIAxes5.Title.String = 'Filter(Ƶ��';
                %�ر��źŵ�
                app.Lamp_2.Color = [0.5 0.5 0.5] ;
            end

        end

        % Value changed function: Switch
        function SwitchValueChanged(app, event)
            %����ť�ϱ߱����£��򲥷�ԭʼ¼������
            if strcmp(app.Switch.Value, 'On')
                sound(abs(app.myRecording),8000)
                %�����Ϸ��źŵƲ��ر��·��źŵ�
                app.OriginaudioLamp.Color = [0 1 0] ;
                app.AfteraudioLamp.Color = [0.5 0.5 0.5] ;
            else
                %�����˲�����������
                sound(abs(app.out),8000);
                %�����·��źŵƲ��ر��Ϸ��źŵ�
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
            title(app.UIAxes, '�����źţ�ʱ��')
            xlabel(app.UIAxes, 'T(s)')
            ylabel(app.UIAxes, 'Y')
            app.UIAxes.PlotBoxAspectRatio = [1 0.514285714285714 0.514285714285714];
            app.UIAxes.TitleFontWeight = 'bold';
            app.UIAxes.Position = [15 337 416 222];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, '�˲����źţ�ʱ��')
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
            title(app.UIAxes4, '�����źţ�Ƶ��')
            xlabel(app.UIAxes4, 'F(Hz)')
            ylabel(app.UIAxes4, 'Y')
            app.UIAxes4.PlotBoxAspectRatio = [1 0.514285714285714 0.514285714285714];
            app.UIAxes4.TitleFontWeight = 'bold';
            app.UIAxes4.Position = [33 15 398 232];

            % Create UIAxes5
            app.UIAxes5 = uiaxes(app.UIFigure);
            title(app.UIAxes5, '�˲����źţ�Ƶ��')
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