function best1=decision_mat(Data)

for ii=1:size(Data,1)


CostFunction=@(x) Sphere(x);        % Cost Function

nVar=5;             % Number of Decision Variables

VarSize=[1 nVar];   % Decision Variables Matrix Size

VarMin=-10;         % Decision Variables Lower Bound
VarMax= 10;         % Decision Variables Upper Bound



MaxIt=10;          % Maximum Number of Iterations

seq_tree=30;                           % Number of trees

nSelectedSite=round(0.5*seq_tree);     % Number of Selected Sites

nEliteSite=round(0.4*nSelectedSite);    % Number of Selected Elite Sites

nSelectedSiteBee=round(0.5*seq_tree);  % Number of Recruited branch for Selected Sites

nEliteSiteBee=2*nSelectedSiteBee;       % Number of Recruited branch for Elite Sites

r=0.1*(VarMax-VarMin);	% Neighborhood Radius

rdamp=0.95;             % Neighborhood Radius Damp Rate


empty_bee.Position=[];
empty_bee.Cost=[];

% Initialize tree Array
ran_tree_daq=repmat(empty_bee,seq_tree,1);

% Create New Solutions
for i=1:seq_tree
    ran_tree_daq(i).Position=unifrnd(VarMin,VarMax,VarSize);
    ran_tree_daq(i).Cost=CostFunction(ran_tree_daq(i).Position);
end

% Sort
[~, SortOrder]=sort([ran_tree_daq.Cost]);
ran_tree_daq=ran_tree_daq(SortOrder);

% Update Best Solution Ever Found
BestSol=ran_tree_daq(1);

% Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);

%%%%%%%%Algorithm Main Loop

for it=1:MaxIt
    
    % Elite Sites
    for i=1:nEliteSite
        
        besttreedaq.Cost=inf;
        
        for j=1:nEliteSiteBee
            newbee.Position=PerformDance(ran_tree_daq(i).Position,r);
            newbee.Cost=CostFunction(newbee.Position);
            if newbee.Cost<besttreedaq.Cost
                besttreedaq=newbee;
            end
        end

        if besttreedaq.Cost<ran_tree_daq(i).Cost
            ran_tree_daq(i)=besttreedaq;
        end
        
    end
    
    % Selected Non-Elite Sites
    for i=nEliteSite+1:nSelectedSite
        
        besttreedaq.Cost=inf;
        
        for j=1:nSelectedSiteBee
            newbee.Position=PerformDance(ran_tree_daq(i).Position,r);
            newbee.Cost=CostFunction(newbee.Position);
            if newbee.Cost<besttreedaq.Cost
                besttreedaq=newbee;
            end
        end

        if besttreedaq.Cost<ran_tree_daq(i).Cost
            ran_tree_daq(i)=besttreedaq;
        end
        
    end
    
    % Non-Selected Sites
    for i=nSelectedSite+1:seq_tree
        ran_tree_daq(i).Position=unifrnd(VarMin,VarMax,VarSize);
        ran_tree_daq(i).Cost=CostFunction(ran_tree_daq(i).Position);
    end
    
    % Sort
    [~, SortOrder]=sort([ran_tree_daq.Cost]);
    ran_tree_daq=ran_tree_daq(SortOrder);
    
    % Update Best Solution Ever Found
    BestSol=ran_tree_daq(1);
    
    % Store Best Cost Ever Found
    BestCost(it)=BestSol.Cost;
    
    % Display Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
    % Damp Neighborhood Radius
    r=r*rdamp;
    xx(ii,:)=Data(ii,:)+BestCost(it);
end
end
xx1=mean(xx);
[bestt b2]=sort(xx1);
best1=b2;
%%%%5 Results





