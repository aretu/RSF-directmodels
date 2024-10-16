function comparison_list = query_table_dynamically(file_name, query_conditions)
    % Query an Excel table dynamically based on multiple column-value conditions,
    % simplifying the process by leveraging MATLAB's built-in table methods.
    %
    % Parameters:
    %   file_name: The Excel file name (with extension, e.g., 'inputparameters.xlsx').
    %   query_conditions: A struct containing column names and the values to query.
    %
    % Returns:
    %   comparison_list: A cell array containing 'name' values matching the query.
    
    % Set options to preserve the original column names
    opts = detectImportOptions(file_name);
    opts.VariableNamingRule = 'modify';  % Ensure column names are valid MATLAB variable names
    
    % Read the Excel file into a table
    data_table = readtable(file_name, opts);
    
    % Get the field names from the query_conditions struct
    query_fields = fieldnames(query_conditions);
    
    % Start with a logical index of all true
    logical_index = true(height(data_table), 1);
    
    % Apply each query condition directly on the table using table methods
    for i = 1:length(query_fields)
        column_name = query_fields{i};
        column_value = query_conditions.(column_name);
        
        % Ensure the column exists in the table
        if ismember(column_name, data_table.Properties.VariableNames)
            % Use ismember for multiple values, supports both numeric and string
            logical_index = logical_index & ismember(data_table{:, column_name}, column_value);
        else
            error(['Column ', column_name, ' does not exist in the table.']);
        end
    end
    
    % Filter the table using logical indexing
    filtered_table = data_table(logical_index, :);
    
    % Extract the 'name' column if it exists, otherwise return empty
    if ismember('name', data_table.Properties.VariableNames)
        comparison_list = filtered_table.name;
    else
        error('The table does not contain a "name" column.');
    end
    
    % Return the comparison list as a string array
    comparison_list = string(comparison_list)';
end
