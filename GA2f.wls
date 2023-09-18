#!/usr/bin/env wolframscript
(* ::Package:: *)

(* ::Input::Initialization:: *)
path="//home//rhorna//R1//"


(* ::Input::Initialization:: *)
filenames:=Table["ronchi"<>IntegerString[i,10]<>"_.png",{i,0,1999}]


(* ::Input::Initialization:: *)
images={}
For[i=1,i<=Length[filenames],i++,images=Append[images,Import[path<>filenames[[i]]]]]


(* ::Input::Initialization:: *)
Print[images[[Range[1,10]]]]


(* ::Input::Initialization:: *)
oft0= {}
For[l=0,l< 5,l++,AppendTo[oft0,0.4 - l*0.04]] ;
ofit0={};
oft0;

Do[AppendTo[ofit0,oft0],400]


(* ::Input::Initialization:: *)
colt0:=Flatten[ofit0]
oft0:=List/@colt0


(* ::Input::Initialization:: *)
Numt0 = {}
For[i=0,i<20,i++, For[j=0,j<20,j++,For[k=0,k<5,k++, AppendTo[Numt0,{ 2*(25 + j *2),-1 +  i*0.05}]]]]


(* ::Input::Initialization:: *)
Print[Numt0[[Range[1,5]]]]


(* ::Input::Initialization:: *)
patht="//home//rhorna//R1//Test//"

filenamest:=Table["ronchi"<>IntegerString[i,10]<>"_.png",{i,0,499}]
test1={}
For[j=1,j<=Length[filenamest],j+=2,test1=Append[test1,Import[patht<>filenamest[[j]]]]]

{}
ront0=Map[List,test1];
oftest0= {}
For[l=0,l< 5,l++,AppendTo[oftest0,0.4 - l*0.04]] ;
ofitest0={};
oftest0;
Do[AppendTo[ofitest0,oftest0],100]
{}


(* ::Input::Initialization:: *)
in2=Flatten[ofitest0];
ro=Table[ront0[[i]],{i,250}];
in2=Table[in2[[i*2]],{i,250}];
in2=Map[List,in2];
Numval={}
For[i=0,i<10,i++, For[j=0,j<10,j++,For[k=0,k<5,k++, AppendTo[Numval,{ 2*(29 + j*2 ),-0.83 +  i*0.05}]]]]
Nval=Table[Numval[[i*2]],{i,250}];
val= <|"In1"->ro,"In2"->in2, "Out"->Nval|>;


(* ::Input::Initialization:: *)
red1:=NetChain[{ConvolutionLayer[20,5],ElementwiseLayer[Ramp],PoolingLayer[2,2],ConvolutionLayer[50,5],ElementwiseLayer[Ramp],PoolingLayer[2,2],FlattenLayer[]}]
sal1:=NetChain[{LinearLayer[500],ElementwiseLayer[Ramp],BatchNormalizationLayer[],DropoutLayer[],LinearLayer[2]}]


(* ::Input::Initialization:: *)
RED1:=NetGraph[{red1,CatenateLayer[],sal1},{{NetPort["In1"]}-> 1,{1,NetPort["In2"]}-> 2->3->{NetPort["Out"]}},"In1"->"Image","In2"->{1},"Out"->{2} ]



(* ::Input::Initialization:: *)
net1=NetTrain[RED1,<|"In1"->images,"In2"->oft0, "Out"->Numt0|>,All,MaxTrainingRounds->200, ValidationSet->val,TrainingStoppingCriterion-><|"Criterion"->"Loss","Patience"->50|>]


(* ::Input::Initialization:: *)
red2:=NetChain[{ConvolutionLayer[20,5],ElementwiseLayer[Ramp],PoolingLayer[2,2],ConvolutionLayer[50,5],ElementwiseLayer[Ramp],PoolingLayer[2,2],FlattenLayer[]}]
sal2:=NetChain[{LinearLayer[500],ElementwiseLayer[Ramp],BatchNormalizationLayer[],DropoutLayer[],LinearLayer[2]}]


(* ::Input::Initialization:: *)
RED2:=NetGraph[{red2,CatenateLayer[],sal2},{{NetPort["In1"]}-> 1,{1,NetPort["In2"]}-> 2->3->{NetPort["Out"]}},"In1"->"Image","In2"->{1},"Out"->{2} ]



(* ::Input::Initialization:: *)
net2=NetTrain[RED2,<|"In1"->images,"In2"->oft0, "Out"->Numt0|>,All,MaxTrainingRounds->300,ValidationSet->Scaled[0.2]]


(* ::Input::Initialization:: *)
red3:=NetChain[{ConvolutionLayer[10,5],ElementwiseLayer[Ramp],PoolingLayer[2,2],ConvolutionLayer[50,5],ElementwiseLayer[Ramp],PoolingLayer[2,2],ConvolutionLayer[100,5],ElementwiseLayer[Ramp],PoolingLayer[4,4],FlattenLayer[]}]
sal3:=NetChain[{LinearLayer[1000],DropoutLayer[],LinearLayer[200],BatchNormalizationLayer[],ElementwiseLayer[Ramp],LinearLayer[20],BatchNormalizationLayer[],ElementwiseLayer[Ramp],LinearLayer[2]}]


(* ::Input::Initialization:: *)
RED3:=NetGraph[{red3,CatenateLayer[],sal3},{{NetPort["In1"]}-> 1,{1,NetPort["In2"]}-> 2->3->{NetPort["Out"]}},"In1"->"Image","In2"->{1},"Out"->{2} ]

net3=NetTrain[RED3,<|"In1"->images,"In2"->oft0, "Out"->Numt0|>,All,MaxTrainingRounds->200,ValidationSet->Scaled[0.05],TrainingStoppingCriterion->"Loss" ]


(* ::Input::Initialization:: *)
red4:=NetChain[{ConvolutionLayer[10,5],ElementwiseLayer[Ramp],PoolingLayer[2,2],ConvolutionLayer[50,5],ElementwiseLayer[Ramp],PoolingLayer[2,2],ConvolutionLayer[100,5],ElementwiseLayer[Ramp],PoolingLayer[4,4],FlattenLayer[]}]
sal4:=NetChain[{LinearLayer[1000],DropoutLayer[],LinearLayer[200],BatchNormalizationLayer[],ElementwiseLayer[Ramp],LinearLayer[20],BatchNormalizationLayer[],ElementwiseLayer[Ramp],LinearLayer[2]}]


(* ::Input::Initialization:: *)
RED4:=NetGraph[{red4,CatenateLayer[],sal4},{{NetPort["In1"]}-> 1,{1,NetPort["In2"]}-> 2->3->{NetPort["Out"]}},"In1"->"Image","In2"->{1},"Out"->{2} ]

net4=NetTrain[RED4,<|"In1"->images,"In2"->oft0, "Out"->Numt0|>,All,MaxTrainingRounds->300,ValidationSet->Scaled[0.1],TrainingStoppingCriterion-><|"Criterion"->"Loss","Patience"->50|>]


(* ::Input::Initialization:: *)
red5:=NetChain[{ConvolutionLayer[10,5],ElementwiseLayer[Ramp],PoolingLayer[2,2],ConvolutionLayer[50,5],ElementwiseLayer[Ramp],PoolingLayer[2,2],ConvolutionLayer[100,5],ElementwiseLayer[Ramp],PoolingLayer[4,4],FlattenLayer[]}]
sal5:=NetChain[{LinearLayer[1000],DropoutLayer[],LinearLayer[200],BatchNormalizationLayer[],ElementwiseLayer[Ramp],LinearLayer[20],BatchNormalizationLayer[],ElementwiseLayer[Ramp],LinearLayer[2]}]


(* ::Input::Initialization:: *)
RED5:=NetGraph[{red5,CatenateLayer[],sal5},{{NetPort["In1"]}-> 1,{1,NetPort["In2"]}-> 2->3->{NetPort["Out"]}},"In1"->"Image","In2"->{1},"Out"->{2} ]

net5=NetTrain[RED5,<|"In1"->images,"In2"->oft0, "Out"->Numt0|>,All,MaxTrainingRounds->400,ValidationSet->val,TrainingStoppingCriterion-><|"Criterion"->"Loss","Patience"->50|> ]


(* ::Input::Initialization:: *)
Export["net1f.wxf",net1]
Export["net2f.wxf",net2]
Export["net3f.wxf",net3]
Export["net4f.wxf",net4]
Export["net5f.wxf",net5]
Export["plot1f.png",net1["FinalPlots"]]
{
 {Export["plot2f.png",net2["FinalPlots"]]},
 {Export["plot3f.png",net3["FinalPlots"]]},
 {Export["plot4f.png",net4["FinalPlots"]]},
 {Export["plot5f.png",net5["FinalPlots"]]}
}
