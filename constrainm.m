temp=[3,1,1;3,1,3;3,4,3;3,4,4;3,2,3;3,2,2;2,1,1;2,1,2;2,3,2;2,3,3;2,4,2;2,4,4;1,3,1;1,3,3;1,4,1;1,4,4;1,2,1;1,2,2;4,1,1;4,1,4;4,3,3;4,3,4;4,2,2;4,2,4;1,1,1;2,2,2;3,3,3;4,4,4;3,3,1;3,3,2;3,3,4;2,2,1;2,2,3;2,2,4;1,1,2;1,1,3;1,1,4;4,4,1;4,4,2;4,4,3];
constrain=temp';
for i=1:length(allMatrix)
    for h=1:length(constrain)
    if  allMatrix(:,i)==constrain(:,h)
    allMatrix(:,i)=[0;0;0];
    end
    end
 
end
index=[];
for i=1:length(allMatrix)
    
    if  allMatrix(:,i)==[0;0;0]
    index=[index i];
    end
    
 
end
allMatrix(:,index)=[];
save('cardMatrix.mat','allMatrix')