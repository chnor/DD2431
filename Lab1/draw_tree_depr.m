
function draw_tree(T, node_names)
    
    treeplot(T);
    [x,y] = treelayout(T);
    x = x';
    y = y';
    
    text(x(:,1), y(:,1), node_names, ...
            'VerticalAlignment', 'bottom', ...
            'HorizontalAlignment', 'right')
    
    children = T(2:end);
    parents = T(children);
    edges_x = (x(children+1) + x(parents+1)) ./ 2;
    edges_y = (y(children+1) + y(parents+1)) ./ 2;
    
    count = size(edges_x, 2);
    name1 = cellstr(num2str((1:count)'));
    
    text(edges_x(:,1), edges_y(:,1), name1, ...
            'VerticalAlignment', 'bottom', ...
            'HorizontalAlignment', 'right')
%     title({'Level Lines'},'FontSize',12,'FontName','Times New Roman');
end