
function NumericalmethodsApp

% Create application window
fig = uifigure('Name','Numerical Methods Solver',...
    'Position',[300 300 400 300]);

% Method selection
uilabel(fig,'Position',[30 245 120 22],...
    'Text','Select Method:');

method = uidropdown(fig,...
    'Items',{'Secant','Newton-Raphson','Runge-Kutta'},...
    'Position',[160 245 180 22]);

% Input fields
uilabel(fig,'Position',[30 200 120 22],'Text','Initial x0:');
x0 = uieditfield(fig,'numeric',...
    'Position',[160 200 180 22],'Value',1.5);

uilabel(fig,'Position',[30 160 120 22],'Text','Initial x1:');
x1 = uieditfield(fig,'numeric',...
    'Position',[160 160 180 22],'Value',2);

% Output area
result = uitextarea(fig,...
    'Position',[30 25 340 90],...
    'Editable','off');

% Calculate button
uibutton(fig,'Text','Calculate',...
    'Position',[50 125 120 25],...
    'ButtonPushedFcn',@calculate);

% Clear button
uibutton(fig,'Text','Clear',...
    'Position',[220 125 120 25],...
    'ButtonPushedFcn',@clearOutput);

% Calculation function
function calculate(~,~)

    f = @(x) x^3-x-2;
    a = x0.Value;
    b = x1.Value;

    switch method.Value

        case 'Secant'
            for k = 1:20
                c = b-f(b)*(b-a)/(f(b)-f(a));
                if abs(c-b)<1e-4, break; end
                a=b; b=c;
            end
            answer = c;

        case 'Newton-Raphson'
            a = x0.Value;
            for k = 1:20
                c = a-f(a)/(3*a^2-1);
                if abs(c-a)<1e-4, break; end
                a=c;
            end
            answer = c;

        case 'Runge-Kutta'
            xv=0; y=1; h=0.1;
            for i=1:2
                k1=h*(xv+y);
                k2=h*(xv+h/2+y+k1/2);
                k3=h*(xv+h/2+y+k2/2);
                k4=h*(xv+h+y+k3);
                y=y+(k1+2*k2+2*k3+k4)/6;
                xv=xv+h;
            end
            answer=y;
    end

    result.Value = {['Calculated result: ',num2str(answer)]};

end

% Clear function
function clearOutput(~,~)
    result.Value = {''};
end

end
