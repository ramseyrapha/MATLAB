
classdef Hostel
    properties
        Name    string   % String storing hostel identifier
        Residents double % Numerical count of student population
    end
    
    methods
        % Constructor Method to initialize the object attributes
        function obj = Hostel(name, residents)
            obj.Name = name;
            obj.Residents = residents;
        end
        
        % Method to calculate demand dynamically in Litres per second (L/s)
        % Formula assumes standard allocation of 120 Litres per capita per day
        function demand = getDemand(obj)
            demand = obj.Residents * 120 / 86400;
        end
    end
end
