function res = simulation_in_Simulink(x1,x2)
    x1, x2
    assignin('base','X1',x1)
    assignin('base','X2',x2)

    sim("Rosenbrock.slx")
    res = simout.Data
end