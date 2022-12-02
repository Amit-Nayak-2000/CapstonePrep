classdef GUI_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        MCG4322BGroup03UIFigure         matlab.ui.Figure
        YoudeservetostepintocomfortLabel  matlab.ui.control.Label
        ExitDesignerButton              matlab.ui.control.Button
        BUILDButton                     matlab.ui.control.Button
        PleaseenterusermeasurementsPanel  matlab.ui.container.Panel
        EditField_c                     matlab.ui.control.NumericEditField
        EditField_t                     matlab.ui.control.NumericEditField
        EditField_w                     matlab.ui.control.NumericEditField
        EditField_h                     matlab.ui.control.NumericEditField
        CalfCircumferencecmSlider       matlab.ui.control.Slider
        CalfCircumferencecmSliderLabel  matlab.ui.control.Label
        WeightKgSlider                  matlab.ui.control.Slider
        WeightKgSliderLabel             matlab.ui.control.Label
        ThighCircumferencecmSlider      matlab.ui.control.Slider
        ThighCircumferencecmSliderLabel  matlab.ui.control.Label
        HeightcmSlider                  matlab.ui.control.Slider
        HeightcmSliderLabel             matlab.ui.control.Label
        Image                           matlab.ui.control.Image
        TabGroup                        matlab.ui.container.TabGroup
        OutputLogTab                    matlab.ui.container.Tab
        TextArea                        matlab.ui.control.TextArea
        SFTab                           matlab.ui.container.Tab
        TextArea_sf                     matlab.ui.control.TextArea
        ICRTab                          matlab.ui.container.Tab
        UIAxes_icr                      matlab.ui.control.UIAxes
        FrontalPlaneTab                 matlab.ui.container.Tab
        UIAxes_frontalplane             matlab.ui.control.UIAxes
        TotalPETab                      matlab.ui.container.Tab
        UIAxes_PE                       matlab.ui.control.UIAxes
        SagittalContributionTab         matlab.ui.container.Tab
        UIAxes_sag                      matlab.ui.control.UIAxes
        OurTeamTab                      matlab.ui.container.Tab
        Image2                          matlab.ui.control.Image
    end

    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)

        end

        % Value changing function: HeightcmSlider
        function HeightSliderValueChanging(app, event)
            userheight = event.Value;
            if (userheight < 100) || (userheight > 200) %If statement to display error message in output log if inputs are outside of specified range.
                app.TextArea.Value = 'Invalid Entry. Please enter a height between 100 cm and 200 cm';
            else
                app.EditField_h.Value = userheight; %Sets text field equal to slider value
                app.TextArea.Value = 'Click BUILD to submit design inputs. Click Exit Designer to close the GUI.';
            end
        end

        % Value changed function: EditField_h
        function heightTextValueChanged(app, event)
            userheighttext = app.EditField_h.Value;
            if (userheighttext < 100) || (userheighttext > 200) %If statement to check if inputs are within specified range
                app.TextArea.Value = 'Invalid Entry. Please enter a height between 100 cm and 200 cm';
            else
                app.HeightcmSlider.Value = userheighttext; %Sets slider value equal to text box input
                app.TextArea.Value = 'Click Generate to submit design inputs. Click Finish to exit the GUI.';
            end
        end

        % Value changing function: WeightKgSlider
        function WeightSliderValueChanging(app, event)
            userweight = event.Value;
            if (userweight < 36) || (userweight > 115) %If statement to display error message in output log if inputs are outside of specified range.
                app.TextArea.Value = 'Invalid Entry. Please enter a weight between 36 kg and 115 kg';
            else
                app.EditField_w.Value = userweight; %Sets text field equal to slider value
                app.TextArea.Value = 'Click BUILD to submit design inputs. Click Exit Designer to close the GUI.';
            end
            
        end

        % Value changed function: EditField_w
        function weightTextValueChanged(app, event)
            userweighttext = app.EditField_w.Value;
            if (userweighttext < 36) || (userweighttext > 115) %If statement to check if inputs are within specified range
                app.TextArea.Value = 'Invalid Entry. Please enter a weight between 36 kg and 115 kg';
            else
                app.WeightKgSlider.Value = userweighttext; %Sets slider value equal to text box input
                app.TextArea.Value = 'Click Generate to submit design inputs. Click Finish to exit the GUI.';
            end
        end

        % Value changing function: ThighCircumferencecmSlider
        function ThighSliderValueChanging(app, event)
            userthigh = event.Value;
            if (userthigh < 33) || (userthigh > 81) %If statement to display error message in output log if inputs are outside of specified range.
                app.TextArea.Value = 'Invalid Entry. Please enter a thigh circumference between 33 cm and 81 cm';
            else
                app.EditField_t.Value = userthigh; %Sets text field equal to slider value
                app.TextArea.Value = 'Click BUILD to submit design inputs. Click Exit Designer to close the GUI.';
            end
            
        end

        % Value changed function: EditField_t
        function thighTextValueChanged(app, event)
            userthightext = app.EditField_w.Value;
            if (userthightext < 33) || (userthightext > 81) %If statement to check if inputs are within specified range
                app.TextArea.Value = 'Invalid Entry. Please enter a thigh circumference between 33 cm and 81 cm';
            else
                app.ThighCircumferencecmSlider.Value = userthightext; %Sets slider value equal to text box input
                app.TextArea.Value = 'Click Generate to submit design inputs. Click Finish to exit the GUI.';
            end
            
        end

        % Value changing function: CalfCircumferencecmSlider
        function CalfSliderValueChanging(app, event)
            usercalf = event.Value;
            if (usercalf < 27) || (usercalf > 61) %If statement to display error message in output log if inputs are outside of specified range.
                app.TextArea.Value = 'Invalid Entry. Please enter a calf circumference between 27 cm and 61 cm';
            else
                app.EditField_c.Value = usercalf; %Sets text field equal to slider value
                app.TextArea.Value = 'Click BUILD to submit design inputs. Click Exit Designer to close the GUI.';
            end
            
        end

        % Value changed function: EditField_c
        function calfTextValueChanged(app, event)
            usercalftext = app.EditField_c.Value;
            if (usercalftext < 27) || (usercalftext > 61) %If statement to check if inputs are within specified range
                app.TextArea.Value = 'Invalid Entry. Please enter a calf circumference between 27 cm and 61 cm';
            else
                app.CalfCircumferencecmSlider.Value = usercalftext; %Sets slider value equal to text box input
                app.TextArea.Value = 'Click Generate to submit design inputs. Click Finish to exit the GUI.';
            end
        end

        % Button pushed function: BUILDButton
        function BUILDButtonPushed(app, event)
            height = app.EditField_h.Value / 100; % Saves latest value from text box to the variable height and converts cm to m
            weight = app.EditField_w.Value; % Saves latest value from text box to the variable weight and converts cm to m
            calfD = (app.EditField_c.Value / pi) / 100; % Saves latest value from calf circumference text box to the variable calfD, converts to diameter and converts cm to m
            thighD = (app.EditField_t.Value / pi) / 100; % Saves latest value from thigh circumference text box to the variable thighCD, converts to diameter and converts cm to m
            calfDmin = (27/pi)/100; 
            calfDmax = (61/pi)/100;
            thighDmin = (33/pi)/100;
            thighDmax = (81/pi)/100;

            if (height < 1) || (height > 2) || (weight < 36) || (weight > 115) || (calfD < calfDmin) || (calfD > calfDmax) || (thighD < thighDmin) || (thighD > thighDmax) %If statement to verify all three inputs are within specified ranges
                app.TextArea.Value = 'Invalid Entry. Please ensure inputs are within the specified ranges.';
            else % If all inputs are within specified ranges, proceed to else statement
                app.TextArea.Value = "Running calculations. We thank you for your patience.";
                drawnow;
               
                % Calls the design code function using input arguments from the GUI
                [percentage, biokneemoment, newkneemoment, totalPE, ICRx, ICRy, Parts, SafetyFactors, OA_KAM, new_KAM, healthy_KAM] = DesignCode(weight, height, thighD, calfD, app); 
                
                
                % Generate plots for ICR, potential energy, frontal plane contribution, moment contribution 
                
                % Clear axes
                cla(app.UIAxes_icr);
                cla(app.UIAxes_PE);
                cla(app.UIAxes_frontalplane);
                cla(app.UIAxes_sag);
                
                % Generate plots
                plot(app.UIAxes_icr, ICRx, ICRy);
                plot(app.UIAxes_PE, percentage, totalPE);
                hold(app.UIAxes_sag,'on');
                plot(app.UIAxes_sag, percentage, biokneemoment, 'DisplayName','Biological Knee Moment');
                plot(app.UIAxes_sag, percentage, newkneemoment, 'DisplayName','New Knee Moment');
                hold(app.UIAxes_sag, 'off');
                legend(app.UIAxes_sag);
                hold(app.UIAxes_frontalplane, 'on');
                plot(app.UIAxes_frontalplane, percentage, OA_KAM, 'DisplayName', 'Osteoarthritis');
                plot(app.UIAxes_frontalplane, percentage, new_KAM, 'DisplayName', 'Brace Corrected');
                plot(app.UIAxes_frontalplane, percentage, healthy_KAM, 'DisplayName', 'Healthy');
                hold(app.UIAxes_frontalplane, 'off');
                legend(app.UIAxes_frontalplane);
                
                
            end
        end

        % Button pushed function: ExitDesignerButton
        function ExitButtonPushed(app, event)
            closereq; %Closes GUI figure
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create MCG4322BGroup03UIFigure and hide until all components are created
            app.MCG4322BGroup03UIFigure = uifigure('Visible', 'off');
            app.MCG4322BGroup03UIFigure.Color = [0.7216 0.8588 0.851];
            app.MCG4322BGroup03UIFigure.Position = [100 100 899 420];
            app.MCG4322BGroup03UIFigure.Name = 'MCG4322B Group 03';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.MCG4322BGroup03UIFigure);
            app.TabGroup.Position = [404 62 481 347];

            % Create OutputLogTab
            app.OutputLogTab = uitab(app.TabGroup);
            app.OutputLogTab.Title = 'Output Log';
            app.OutputLogTab.BackgroundColor = [0.0431 0.1686 0.2314];

            % Create TextArea
            app.TextArea = uitextarea(app.OutputLogTab);
            app.TextArea.Position = [11 12 459 301];
            app.TextArea.Value = {'Click BUILD to submit design inputs. '; 'Click Exit Designer to quit the GUI.'};

            % Create SFTab
            app.SFTab = uitab(app.TabGroup);
            app.SFTab.Title = 'S.F.';
            app.SFTab.BackgroundColor = [0.0392 0.1686 0.2314];

            % Create TextArea_sf
            app.TextArea_sf = uitextarea(app.SFTab);
            app.TextArea_sf.Position = [10 12 459 301];

            % Create ICRTab
            app.ICRTab = uitab(app.TabGroup);
            app.ICRTab.Title = 'ICR';
            app.ICRTab.BackgroundColor = [0.9569 0.9569 0.9765];

            % Create UIAxes_icr
            app.UIAxes_icr = uiaxes(app.ICRTab);
            title(app.UIAxes_icr, 'Instantaneous Center of Rotation')
            xlabel(app.UIAxes_icr, 'X Distance from SA joint (m)')
            ylabel(app.UIAxes_icr, 'Y Distance from SA joint (m)')
            zlabel(app.UIAxes_icr, 'Z')
            app.UIAxes_icr.Position = [1 1 480 322];

            % Create FrontalPlaneTab
            app.FrontalPlaneTab = uitab(app.TabGroup);
            app.FrontalPlaneTab.Title = 'Frontal Plane';
            app.FrontalPlaneTab.BackgroundColor = [0.9569 0.9569 0.9765];

            % Create UIAxes_frontalplane
            app.UIAxes_frontalplane = uiaxes(app.FrontalPlaneTab);
            title(app.UIAxes_frontalplane, 'Frontal Plane Knee Moment')
            xlabel(app.UIAxes_frontalplane, 'Percent of Gait Cycle (%)')
            ylabel(app.UIAxes_frontalplane, 'Moment (Nm)')
            zlabel(app.UIAxes_frontalplane, 'Z')
            app.UIAxes_frontalplane.Position = [14 4 455 313];

            % Create TotalPETab
            app.TotalPETab = uitab(app.TabGroup);
            app.TotalPETab.Title = 'Total PE';
            app.TotalPETab.BackgroundColor = [0.9569 0.9569 0.9765];

            % Create UIAxes_PE
            app.UIAxes_PE = uiaxes(app.TotalPETab);
            title(app.UIAxes_PE, 'Potential Energy of Knee Brace')
            xlabel(app.UIAxes_PE, 'Percent of Gait Cycle (%)')
            ylabel(app.UIAxes_PE, 'Potential Energy (J)')
            zlabel(app.UIAxes_PE, 'Z')
            app.UIAxes_PE.Position = [7 4 469 312];

            % Create SagittalContributionTab
            app.SagittalContributionTab = uitab(app.TabGroup);
            app.SagittalContributionTab.Title = 'Sagittal Contribution';
            app.SagittalContributionTab.BackgroundColor = [0.9569 0.9569 0.9765];

            % Create UIAxes_sag
            app.UIAxes_sag = uiaxes(app.SagittalContributionTab);
            title(app.UIAxes_sag, 'Sagittal Moment Contribution')
            xlabel(app.UIAxes_sag, 'Percent of Gait Cycle (%)')
            ylabel(app.UIAxes_sag, 'Moment (Nm)')
            zlabel(app.UIAxes_sag, 'Z')
            app.UIAxes_sag.Position = [11 12 459 297];

            % Create OurTeamTab
            app.OurTeamTab = uitab(app.TabGroup);
            app.OurTeamTab.Title = 'Our Team';
            app.OurTeamTab.BackgroundColor = [0.0392 0.1686 0.2314];

            % Create Image2
            app.Image2 = uiimage(app.OurTeamTab);
            app.Image2.Position = [1 19 479 292];
            app.Image2.ImageSource = 'Slide64.jpg';

            % Create Image
            app.Image = uiimage(app.MCG4322BGroup03UIFigure);
            app.Image.ScaleMethod = 'fill';
            app.Image.Position = [18 325 371 84];

            % Create PleaseenterusermeasurementsPanel
            app.PleaseenterusermeasurementsPanel = uipanel(app.MCG4322BGroup03UIFigure);
            app.PleaseenterusermeasurementsPanel.Title = 'Please enter user measurements. ';
            app.PleaseenterusermeasurementsPanel.BackgroundColor = [0.9569 0.9569 0.9765];
            app.PleaseenterusermeasurementsPanel.Position = [18 62 371 248];

            % Create HeightcmSliderLabel
            app.HeightcmSliderLabel = uilabel(app.PleaseenterusermeasurementsPanel);
            app.HeightcmSliderLabel.FontName = 'NewCenturySchoolBook';
            app.HeightcmSliderLabel.Position = [5 178 97 43];
            app.HeightcmSliderLabel.Text = 'Height (cm):';

            % Create HeightcmSlider
            app.HeightcmSlider = uislider(app.PleaseenterusermeasurementsPanel);
            app.HeightcmSlider.Limits = [100 200];
            app.HeightcmSlider.ValueChangingFcn = createCallbackFcn(app, @HeightSliderValueChanging, true);
            app.HeightcmSlider.FontName = 'Bookman';
            app.HeightcmSlider.Position = [126 208 155 3];
            app.HeightcmSlider.Value = 100;

            % Create ThighCircumferencecmSliderLabel
            app.ThighCircumferencecmSliderLabel = uilabel(app.PleaseenterusermeasurementsPanel);
            app.ThighCircumferencecmSliderLabel.WordWrap = 'on';
            app.ThighCircumferencecmSliderLabel.Position = [5 75 122 42];
            app.ThighCircumferencecmSliderLabel.Text = 'Thigh Circumference (cm)';

            % Create ThighCircumferencecmSlider
            app.ThighCircumferencecmSlider = uislider(app.PleaseenterusermeasurementsPanel);
            app.ThighCircumferencecmSlider.Limits = [33 81];
            app.ThighCircumferencecmSlider.ValueChangingFcn = createCallbackFcn(app, @ThighSliderValueChanging, true);
            app.ThighCircumferencecmSlider.Position = [126 105 159 3];
            app.ThighCircumferencecmSlider.Value = 33;

            % Create WeightKgSliderLabel
            app.WeightKgSliderLabel = uilabel(app.PleaseenterusermeasurementsPanel);
            app.WeightKgSliderLabel.Position = [5 127 117 43];
            app.WeightKgSliderLabel.Text = 'Weight (Kg):';

            % Create WeightKgSlider
            app.WeightKgSlider = uislider(app.PleaseenterusermeasurementsPanel);
            app.WeightKgSlider.Limits = [40 115];
            app.WeightKgSlider.ValueChangingFcn = createCallbackFcn(app, @WeightSliderValueChanging, true);
            app.WeightKgSlider.FontSize = 11;
            app.WeightKgSlider.Position = [126 157 161 3];
            app.WeightKgSlider.Value = 40;

            % Create CalfCircumferencecmSliderLabel
            app.CalfCircumferencecmSliderLabel = uilabel(app.PleaseenterusermeasurementsPanel);
            app.CalfCircumferencecmSliderLabel.WordWrap = 'on';
            app.CalfCircumferencecmSliderLabel.Position = [5 23 107 42];
            app.CalfCircumferencecmSliderLabel.Text = 'Calf Circumference (cm)';

            % Create CalfCircumferencecmSlider
            app.CalfCircumferencecmSlider = uislider(app.PleaseenterusermeasurementsPanel);
            app.CalfCircumferencecmSlider.Limits = [27 61];
            app.CalfCircumferencecmSlider.ValueChangingFcn = createCallbackFcn(app, @CalfSliderValueChanging, true);
            app.CalfCircumferencecmSlider.Position = [126 53 159 3];
            app.CalfCircumferencecmSlider.Value = 27;

            % Create EditField_h
            app.EditField_h = uieditfield(app.PleaseenterusermeasurementsPanel, 'numeric');
            app.EditField_h.ValueChangedFcn = createCallbackFcn(app, @heightTextValueChanged, true);
            app.EditField_h.Position = [295 198 65 22];
            app.EditField_h.Value = 100;

            % Create EditField_w
            app.EditField_w = uieditfield(app.PleaseenterusermeasurementsPanel, 'numeric');
            app.EditField_w.ValueChangedFcn = createCallbackFcn(app, @weightTextValueChanged, true);
            app.EditField_w.Position = [295 148 65 22];
            app.EditField_w.Value = 36;

            % Create EditField_t
            app.EditField_t = uieditfield(app.PleaseenterusermeasurementsPanel, 'numeric');
            app.EditField_t.ValueChangedFcn = createCallbackFcn(app, @thighTextValueChanged, true);
            app.EditField_t.Position = [295 95 65 22];
            app.EditField_t.Value = 33;

            % Create EditField_c
            app.EditField_c = uieditfield(app.PleaseenterusermeasurementsPanel, 'numeric');
            app.EditField_c.ValueChangedFcn = createCallbackFcn(app, @calfTextValueChanged, true);
            app.EditField_c.Position = [295 43 65 22];
            app.EditField_c.Value = 27;

            % Create BUILDButton
            app.BUILDButton = uibutton(app.MCG4322BGroup03UIFigure, 'push');
            app.BUILDButton.ButtonPushedFcn = createCallbackFcn(app, @BUILDButtonPushed, true);
            app.BUILDButton.BackgroundColor = [0.0431 0.1686 0.2314];
            app.BUILDButton.FontColor = [0.9569 0.9569 0.9765];
            app.BUILDButton.Position = [18 12 186 39];
            app.BUILDButton.Text = 'BUILD';

            % Create ExitDesignerButton
            app.ExitDesignerButton = uibutton(app.MCG4322BGroup03UIFigure, 'push');
            app.ExitDesignerButton.ButtonPushedFcn = createCallbackFcn(app, @ExitButtonPushed, true);
            app.ExitDesignerButton.BackgroundColor = [0.0431 0.1686 0.2314];
            app.ExitDesignerButton.FontAngle = 'italic';
            app.ExitDesignerButton.FontColor = [0.9569 0.9569 0.9765];
            app.ExitDesignerButton.Position = [215 12 174 39];
            app.ExitDesignerButton.Text = 'Exit Designer';

            % Create YoudeservetostepintocomfortLabel
            app.YoudeservetostepintocomfortLabel = uilabel(app.MCG4322BGroup03UIFigure);
            app.YoudeservetostepintocomfortLabel.HorizontalAlignment = 'center';
            app.YoudeservetostepintocomfortLabel.FontName = 'PingFang TC';
            app.YoudeservetostepintocomfortLabel.FontSize = 24;
            app.YoudeservetostepintocomfortLabel.FontWeight = 'bold';
            app.YoudeservetostepintocomfortLabel.FontAngle = 'italic';
            app.YoudeservetostepintocomfortLabel.FontColor = [0.149 0.149 0.149];
            app.YoudeservetostepintocomfortLabel.Position = [405 12 479 39];
            app.YoudeservetostepintocomfortLabel.Text = 'You deserve to step into comfort';

            % Show the figure after all components are created
            app.MCG4322BGroup03UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = GUI_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.MCG4322BGroup03UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.MCG4322BGroup03UIFigure)
        end
    end
end