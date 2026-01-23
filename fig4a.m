% 1. Global Settings (Professional Style)
% ------------------------------
set(groot, 'defaultAxesFontName', 'Times New Roman');
set(groot, 'defaultTextFontName', 'Times New Roman');
set(groot, 'defaultLegendFontSize', 8);  % 图例字体8号
set(groot, 'defaultAxesFontSize', 8);   % 坐标轴字号12
set(groot, 'defaultLineLineWidth', 2.0); % 线宽2.0

% ------------------------------
% 2. Data Structure & Parameters
% ------------------------------
% Scene & User Configuration
n_scenes = 4;                                  % 4 scenes (2x2 subplots)
n_users = 3;                                   % 3 users per scene
n_hours = 24;                                  % 24 hours (x-axis: 1-24)
scene_rows = cell(n_scenes, 1);                % Row range for each scene
for s = 1:n_scenes
    scene_rows{s} = (3*(s-1)+1):(3*s);         % 3 rows = 1 scene (User 1-3)
end

% Load Type Definition
load_info = struct();
load_info.types = {'Reference', 'Normal', 'Worst-Case'};
load_info.styles = {'--', ':', '-'};            % Dashed, Dotted, Solid

% User Definition with Specified Colors
user_info = struct();
user_info.names = {'User 1', 'User 2', 'User 3'};
% 使用您指定的颜色方案 [0.2 0.4 0.8], [0.8 0.4 0.2], [0 0.6 0.3], [0.6 0 0.3]
% 其中红色调整为纯正红色 [0.8 0.2 0.2]
% user_info.colors = {[0.2941, 0.5804, 0.7804],  % 深蓝色 - User 1
%                     [0.9804, 0.0078, 0.0078],  % 正红色 - User 2 (原[0.8 0.4 0.2]改为[0.8 0.2 0.2])
%                     [0.4510, 0.7412, 0.4196]};   % 深绿色 - User 3
user_info.colors =  {[0.2941, 0.5804, 0.7804],
    [0.8 0.2 0.2],  % 正红色 - 容量
          [0 0.6 0.3]};   % 紫色 - 成本
extra_colors = [0.6 0 0.3];        % 紫红色 - 备用颜色
user_info.y_pos = 1:n_users;       % Fixed y-position (1,2,3)

% ------------------------------
% 3. Create Figure with Specified Ratio (6.53:8.87)
% ------------------------------
width = 8.87;   % inches
height = 6.53;  % inches
fig = figure('Units', 'inches', 'Position', [1, 1, width, height]);
set(fig, 'Color', 'white');

% ------------------------------
% 4. Plot 3D Curves for Each Scene
% ------------------------------
for s = 1:n_scenes
    current_rows = scene_rows{s};  % e.g., Scene 1: rows 1-3

    % Create 3D subplot
    ax = subplot(2, 2, s, 'Projection', 'orthographic');
    hold on;
    box on;
    grid on;
    set(ax, 'GridColor', [0.8, 0.8, 0.8], 'GridAlpha', 0.7, ...
            'FontName', 'Times New Roman'); % 强制字体

    % Plot curves for all users & load types
    for u = 1:n_users
        user_row = current_rows(u);
        pload_data = (pload(user_row, :)-RES(user_row, :));
        nl_data = NL(user_row, :);
        wl_data = WL(user_row, :);
        user_loads = {pload_data, nl_data, wl_data};

        for lt = 1:length(load_info.types)
            plot3(1:n_hours, ...
                repmat(user_info.y_pos(u), 1, n_hours), ...
                user_loads{lt}, ...
                'LineStyle', load_info.styles{lt}, ...
                'Color', user_info.colors{u}, ...
                'LineWidth', 2.2);
        end
    end

   % Axes & Title Settings
title(['Scenario ' num2str(s)], 'FontSize', 8, ...
      'FontName', 'Times New Roman'); % 移除FontWeight
xlabel('Time (h)', 'FontSize', 8, ...
      'FontName', 'Times New Roman'); % 添加空格，移除FontWeight
ylabel('User', 'FontSize', 8, ...
      'FontName', 'Times New Roman'); % 移除FontWeight
zlabel('Power (kW)', 'FontSize', 8, ...
      'FontName', 'Times New Roman'); % 添加空格，移除FontWeight

    set(ax, 'XLim', [1, n_hours], 'XTick', [1, 6, 12, 18, 24]);
    set(ax, 'YLim', [0.5, n_users+0.5], 'YTick', user_info.y_pos, ...
           'YTickLabel', user_info.names);
    z_min = min([pload(:); NL(:); WL(:)]) * 0.9;
    z_max = max([pload(:); NL(:); WL(:)]) * 1.1;
    set(ax, 'ZLim', [z_min, z_max]);
    view(40, 35);
    zoom(ax, 1.1);
end

% ------------------------------
% 5. Unified Legend System (8pt Font)
% ------------------------------
% User Color Legend (Left)
user_legend = axes('Position', [0.05, 0.35, 0.2, 0.3], 'Visible', 'off');
hold on;
for u = 1:n_users
    plot(0, 0, 'Color', user_info.colors{u}, 'LineWidth', 3, ...
         'DisplayName', user_info.names{u});
end
legend(user_legend, 'show', 'Location', 'west', 'Box', 'off', ...
       'FontSize', 8, 'FontName', 'Times New Roman');

% Line Style Legend (Right)
line_legend = axes('Position', [0.75, 0.35, 0.2, 0.3], 'Visible', 'off');
hold on;
for lt = 1:length(load_info.types)
    plot(0, 0, 'k', 'LineStyle', load_info.styles{lt}, 'LineWidth', 2.2, ...
         'DisplayName', load_info.types{lt});
end
% ====================== 1. 全局设置（极简矢量友好版） ======================
% 清空环境


% % 全局字体（仅保留核心设置，减少矢量块）
% set(groot, 'defaultAxesFontName', 'Times New Roman');
% set(groot, 'defaultTextFontName', 'Times New Roman');
% set(groot, 'defaultLegendFontSize', 8);
% set(groot, 'defaultAxesFontSize', 8);
% set(groot, 'defaultLineLineWidth', 2.0);
% 
% % ====================== 2. 数据参数（保持你的逻辑） ======================
% n_scenes = 4;          % 4个子图（2x2）
% n_users = 3;           % 每个场景3个用户
% n_hours = 24;          % 24小时
% scene_rows = cell(n_scenes, 1);
% for s = 1:n_scenes
%     scene_rows{s} = (3*(s-1)+1):(3*s);
% end
% 
% % 负荷类型（简化样式，减少矢量复杂度）
% load_info = struct();
% load_info.types = {'Reference', 'Normal', 'Worst-Case'};
% load_info.styles = {'--', ':', '-'}; % 仅保留核心线型
% 
% % 用户配置（固定颜色，减少颜色变体）
% user_info = struct();
% user_info.names = {'User 1', 'User 2', 'User 3'};
% user_info.colors = {[0.2941, 0.5804, 0.7804],  % 蓝-User1
%                     [0.8, 0.2, 0.2],           % 红-User2
%                     [0, 0.6, 0.3]};             % 绿-User3
% user_info.y_pos = 1:n_users;
% 
% % ====================== 3. 模拟数据（避免依赖外部变量，你可替换为真实数据） ======================
% % % 若有真实的pload/RES/NL/WL，注释以下模拟代码即可
% % pload = rand(12,24)*100;  % 12行（4场景×3用户）×24小时
% % RES = rand(12,24)*20;
% % NL = rand(12,24)*90;
% % WL = rand(12,24)*110;
% 
% % ====================== 4. 创建图形（极简矢量模式） ======================
% width = 8.87;   % inches
% height = 6.53;  % inches
% fig = figure('Units', 'inches', 'Position', [1, 1, width, height]);
% set(fig, 'Color', 'white');
% set(fig, 'Renderer', 'painters'); % 关键：使用矢量渲染器，避免光栅化拆分
% 
% % ====================== 5. 绘制子图（简化元素，减少拆分） ======================
% for s = 1:n_scenes
%     current_rows = scene_rows{s};
% 
%     % 创建3D子图（关闭网格，减少矢量块）
%     ax = subplot(2, 2, s, 'Projection', 'orthographic');
%     hold on;
%     box on; % 仅保留外框，关闭网格（网格是拆分重灾区）
%     set(ax, 'GridAlpha', 0, 'XGrid','off','YGrid','off','ZGrid','off',...
%         'BoxStyle','full', 'LineWidth',1); % 关闭网格，简化边框
% 
%     % 绘制用户曲线（合并同类元素，减少矢量数量）
%     for u = 1:n_users
%         user_row = current_rows(u);
%         pload_data = pload(user_row, :) - RES(user_row, :);
%         nl_data = NL(user_row, :);
%         wl_data = WL(user_row, :);
%         user_loads = {pload_data, nl_data, wl_data};
% 
%         for lt = 1:length(load_info.types)
%             plot3(1:n_hours, repmat(user_info.y_pos(u),1,n_hours), user_loads{lt},...
%                 'LineStyle', load_info.styles{lt}, 'Color', user_info.colors{u},...
%                 'LineWidth', 2.2, 'Marker','none'); % 无标记，减少矢量块
%         end
%     end
% 
%     % 坐标轴设置（简化刻度，减少文本块）
%     title(['Scenario ' num2str(s)], 'FontSize',8);
%     xlabel('Time (h)', 'FontSize',8);
%     ylabel('User', 'FontSize',8);
%     zlabel('Power (kW)', 'FontSize',8);
% 
%     set(ax, 'XLim', [1, n_hours], 'XTick', [1,6,12,18,24], 'XTickLabelMode','auto');
%     set(ax, 'YLim', [0.5, n_users+0.5], 'YTick', user_info.y_pos, 'YTickLabel', user_info.names);
%     z_min = min([pload(:); NL(:); WL(:)])*0.9;
%     z_max = max([pload(:); NL(:); WL(:)])*1.1;
%     set(ax, 'ZLim', [z_min, z_max]);
%     view(40, 35);
%     zoom(ax, 1.1);
% end
% 
% % ====================== 6. 统一图例（合并图例元素，减少拆分） ======================
% % 合并图例（一个图例代替两个，减少矢量块）
% legend_ax = axes('Position', [0.4, 0.02, 0.2, 0.15], 'Visible','off');
% hold on;
% % 颜色+线型组合图例
% plot_handles = [];
% plot_labels = [];
% for u = 1:n_users
%     for lt = 1:length(load_info.types)
%         h = plot(0,0, 'Color',user_info.colors{u}, 'LineStyle',load_info.styles{lt},...
%             'LineWidth',2.2, 'DisplayName',[user_info.names{u} ' - ' load_info.types{lt}]);
%         plot_handles = [plot_handles, h];
%         plot_labels = [plot_labels, [user_info.names{u} ' - ' load_info.types{lt}]];
%     end
% end
% legend(legend_ax, plot_handles, plot_labels, 'Location','north', 'NumColumns',3,...
%     'Box','off', 'FontSize',7, 'FontName','Times New Roman');
% 
