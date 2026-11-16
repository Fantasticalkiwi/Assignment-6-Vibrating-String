% Function that simulates the vibrating string.
% INPUTS: None
% OUTPUTS: None
function string_simulation()
    % initialize string parameters
    string_params = init_string_params();

    %load string_params into rate function
    my_rate_func = @(t_in,V_in) string_rate_func01(t_in,V_in,string_params);

    %initial conditions
    U0 = [0; 0; 0];
    dUdt0 = [2; -1; 2];
    V0 = [U0;dUdt0];
    tspan = [0 10];
    
    %run the integration
    [tlist,Vlist] = explicit_RK_variable_step_integration(my_rate_func,tspan,V0,...
        h_ref,BT_struct,p,error_desired,growth_limit);
    %your code to generate an animation of the system
end

% possibly helpful simulation code
% %INPUTS: 
% % vidflag: boolean describing whether or not a video should be saved
% %OUTPUTS: None
% function simulate_box(vidflag)
%     % optional argument that defaults to off
%     % if true or 1, will save video
%     arguments
%         vidflag (1,:) double = 0
%     end
%
%     % run the integration
%     [tlist,V_nonlinear] = explicit_RK_variable_step_integration(func_box,tspan,V0, ...
%                    href,BT_struct,p,error_desired,growth_limit);
% 
%     % simulate the nonlinear vibrating box
%     % save as video if vidflag true
%     if vidflag
%         mypath1 = 'C:\Users\ccirone\Downloads\';
%         fname='square_animation.avi';
%         input_fname = [mypath1, fname];
% 
%         %create a videowriter, which will write frames to the animation file
%         writerObj = VideoWriter(input_fname);
%         open(writerObj); %must call open before writing any frames
%     end
% 
%     % initialize the current figure and save as object
%     fig1 = figure(1);
%     clf
% 
%     %set up plot styling
%     hold on;
%     axis equal; axis square;
%     axis([-10,10,-10,10]);
%     xlabel("$X$ Position (-)", Interpreter="latex");
%     ylabel("$Y$ Position (-)", Interpreter="latex");
%     title("Box Simulation", Interpreter="latex")
%     set(gca,'TickLabelInterpreter','latex')
%     % xticks([-100 -80 -60 -40 -20 0 20 40 60])
%     fontsize(scale=2)
% 
%     % forces the video to be high-quality
%     set(fig1,'units','pixels','position',[0 0 1440 1080])
%     % initialize box
%     origin = plot(0, 0, 'black');
% 
%      for j = 1:length(tlist)
%         % initialize parameters
%         x = V_nonlinear(1,j);
%         y = V_nonlinear(2,j);
%         theta = V_nonlinear(3, j);
%         p_box_reframed = compute_rbt(x, y, theta, p_box);
% 
%         % draw box
%         bound = box_params.boundary_pts;
%         box_bound = compute_rbt(x, y, theta, bound);
%         set(origin, 'xdata', box_bound(1, :), 'ydata', box_bound(2, :));
% 
%         drawnow;
% 
%         if vidflag
%             %capture a frame (what is currently plotted)
%             current_frame = getframe(fig1);
%             %write the frame to the video
%             writeVideo(writerObj,current_frame);
%             if length(V_nonlinear) == j
%                 %must call close after all frames are written to save the video
%                 close(writerObj);
%                 length(xfoot)
%             end
%         end
%     end
% end