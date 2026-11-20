% Function that simulates the vibrating string.
% INPUTS: None
% OUTPUTS: None
function string_simulation(modality, vidflag)
    % optional argument that defaults to off
    % if true or 1, will save video
    arguments
        modality (1,:) double = 0;
        vidflag (1,:) double = 0;
    end

    % initialize string parameters
    string_params = init_string_params();
    n = string_params.n;
    dx = string_params.dx;
    Uf_func = string_params.Uf_func;

    %load string_params into rate function
    my_rate_func = @(t_in,V_in) string_rate_func01(t_in,V_in,string_params);

    % initial conditions
    U0 = [0; 0; 0];
    dUdt0 = [2; -1; 2];
    V0 = [U0;dUdt0];
    tspan = [0 10];
    h_ref = 0.1;
    [BT_struct, p] = init_BT("Fehlberg");
    error_desired = 1e-6;
    growth_limit = 5;

    % run the integration
    [tlist,Vlist] = explicit_RK_variable_step_integration(my_rate_func,tspan,V0,...
        h_ref,BT_struct,p,error_desired,growth_limit);

    if vidflag
        mypath1 = 'C:\Users\kyue\OneDrive - Olin College of Engineering\Documents\MATLAB\Numerical Methods\Assignment-6-Vibrating-String';
        fname='string_vib.avi';
        input_fname = [mypath1, fname];

        %create a videowriter, which will write frames to the animation file
        writerObj = VideoWriter(input_fname);
        open(writerObj); %must call open before writing any frames
    end

    % initialize the current figure and save as object
    % fig1 = figure(1);
    ax_size = [-1,10,-2,2];

    % for plotting mode shapes, create a tiled layout
    fig1 = figure(1);
    if modality > 0
        t = tiledlayout(2,1,'TileSpacing','compact','Padding','compact');
    else
        title("String Simulation", Interpreter="latex")
    end
    clf

    % forces the video to be high-quality
    set(fig1,'units','pixels','position',[0 0 1440 1080])

    % initialize box
    U = Vlist(1:n,:);

    % if you want to plot a mode shape, initialize its tile
    if modality > 0
        nexttile(2)
        modal_string = plot(0, 0, '.-', 'Color', 'k', 'MarkerEdgeColor', 'b', ...
            'LineWidth', 2, 'MarkerSize', 20);

        %set up plot styling
        axis equal; 
        axis(ax_size);
        xlabel("$X$ Position (-)", Interpreter="latex");
        ylabel("$Y$ Position (-)", Interpreter="latex");
        title(sprintf("Mode Shape %g",modality), Interpreter="latex");
        set(gca,'TickLabelInterpreter','latex')
        % xticks([-100 -80 -60 -40 -20 0 20 40 60])

        nexttile(1)
        hold on; string = plot(0, 0); % do this to get the title to show
        sgtitle("String Simulation: Modal Comparison", Interpreter="latex")
        title("Standard Movement", Interpreter="latex");
    end

    % initialize the regular string
    string = plot(0, 0, '.-', 'Color', 'k', 'MarkerEdgeColor', 'r', ...
        'LineWidth', 2, 'MarkerSize', 20);

    %set up plot styling
    axis equal; 
    axis(ax_size);
    xlabel("$X$ Position (-)", Interpreter="latex");
    ylabel("$Y$ Position (-)", Interpreter="latex");
    set(gca,'TickLabelInterpreter','latex')
    % xticks([-100 -80 -60 -40 -20 0 20 40 60])
    fontsize(scale=1.5)

    for j = 1:length(tlist)
        Uf = Uf_func(tlist(j));
        x_positions = linspace(0,dx*n+2,n+2);
        y_positions = [0;U(:,j);Uf];
        set(string, 'xdata', x_positions, 'ydata', y_positions);
        axis equal;
        axis(ax_size);

        if modality > 0
            nexttile(2)
            Uf = Uf_func(tlist(j));
            x_positions = linspace(0,dx*n+2,n+2);
            y_positions = [0;U(:,j);Uf];
            set(modal_string, 'xdata', x_positions, 'ydata', y_positions);
            axis equal;
            axis(ax_size);            
            drawnow;

            nexttile(1)
        else
            drawnow;
        end

        if vidflag
            %capture a frame (what is currently plotted)
            current_frame = getframe(fig1);
            %write the frame to the video
            writeVideo(writerObj,current_frame);
            
            if length(tlist) == j
                %must call close after all frames are written to save the video
                close(writerObj);
            end
        end
    end
end