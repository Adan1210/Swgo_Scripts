#!/usr/bin/env wolframscript
(* ::Package:: *)

(* ::Input::Initialization:: *)
path="//home//rhorna//shower//Swgo_Scripts//images//"


(* ::Input::Initialization:: *)
filenames:=Table["shower600_"<>IntegerString[i,10]<>".png",{i,1,1600}]


(* ::Input::Initialization:: *)
images={}
For[i=1,i<=Length[filenames],i++,images=Append[images,Import[path<>filenames[[i]]]]]
images = ColorConvert[images, "Grayscale"];

(* ::Input::Initialization:: *)
data = Import["/home/rhorna/shower/Swgo_Scripts/energies.txt", "Table"];
numericData = ToExpression[data];
energies = numericData[[Range[1,1600]]];

(* ::Input::Initialization:: *)
red1:=NetChain[{ConvolutionLayer[20,5],ElementwiseLayer[Ramp],PoolingLayer[2,2],ConvolutionLayer[50,5],ElementwiseLayer[Ramp],PoolingLayer[2,2],FlattenLayer[]}]
sal1:=NetChain[{LinearLayer[500],ElementwiseLayer[Ramp],BatchNormalizationLayer[],DropoutLayer[],LinearLayer[]}]


(* ::Input::Initialization:: *)
RED1:=NetGraph[{red1,sal1},{{NetPort["In1"]}-> 1-> 2->{NetPort["Out"]}},"In1"->"Image","Out"->{1} ]



(* ::Input::Initialization:: *)
net1=NetTrain[RED1,<|"In1"->images, "Out"->energies|>,All,MaxTrainingRounds->500, ValidationSet->Scaled[0.1],TrainingStoppingCriterion-><|"Criterion"->"Loss","Patience"->250|>]


(* ::Input::Initialization:: *)
red2:=NetChain[{ConvolutionLayer[20,5],ElementwiseLayer[Ramp],PoolingLayer[2,2],ConvolutionLayer[50,5],ElementwiseLayer[Ramp],PoolingLayer[2,2],FlattenLayer[]}]
sal2:=NetChain[{LinearLayer[500],ElementwiseLayer[Ramp],BatchNormalizationLayer[],DropoutLayer[],LinearLayer[]}]


(* ::Input::Initialization:: *)
RED2:=NetGraph[{red2,sal2},{{NetPort["In1"]}-> 1-> 2->{NetPort["Out"]}},"In1"->"Image","Out"->{1} ]



(* ::Input::Initialization:: *)
net2=NetTrain[RED2,<|"In1"->images,"Out"->energies|>,All,MaxTrainingRounds->300,ValidationSet->Scaled[0.2]]


(* ::Input::Initialization:: *)
red3:=NetChain[{ConvolutionLayer[10,5],ElementwiseLayer[Ramp],PoolingLayer[2,2],ConvolutionLayer[50,5],ElementwiseLayer[Ramp],PoolingLayer[2,2],ConvolutionLayer[100,5],ElementwiseLayer[Ramp],PoolingLayer[4,4],FlattenLayer[]}]
sal3:=NetChain[{LinearLayer[1000],DropoutLayer[],LinearLayer[200],BatchNormalizationLayer[],ElementwiseLayer[Ramp],LinearLayer[20],BatchNormalizationLayer[],ElementwiseLayer[Ramp],LinearLayer[]}]


(* ::Input::Initialization:: *)
RED3:=NetGraph[{red3,sal3},{{NetPort["In1"]}-> 1-> 2->{NetPort["Out"]}},"In1"->"Image","Out"->{1} ]

net3=NetTrain[RED3,<|"In1"->images,"Out"->energies|>,All,MaxTrainingRounds->600,ValidationSet->Scaled[0.05],TrainingStoppingCriterion->"Loss" ]


(* ::Input::Initialization:: *)
red4:=NetChain[{ConvolutionLayer[10,5],ElementwiseLayer[Ramp],PoolingLayer[2,2],ConvolutionLayer[50,5],ElementwiseLayer[Ramp],PoolingLayer[2,2],ConvolutionLayer[100,5],ElementwiseLayer[Ramp],PoolingLayer[4,4],FlattenLayer[]}]
sal4:=NetChain[{LinearLayer[1000],DropoutLayer[],LinearLayer[200],BatchNormalizationLayer[],ElementwiseLayer[Ramp],LinearLayer[20],BatchNormalizationLayer[],ElementwiseLayer[Ramp],LinearLayer[]}]


(* ::Input::Initialization:: *)
RED4:=NetGraph[{red4,sal4},{{NetPort["In1"]}-> 1-> 2->{NetPort["Out"]}},"In1"->"Image","Out"->{1} ]

net4=NetTrain[RED4,<|"In1"->images,"Out"->energies|>,All,MaxTrainingRounds->600,ValidationSet->Scaled[0.1],TrainingStoppingCriterion-><|"Criterion"->"Loss","Patience"->150|>]


(* ::Input::Initialization:: *)
red5:=NetChain[{ConvolutionLayer[10,5],ElementwiseLayer[Ramp],PoolingLayer[2,2],ConvolutionLayer[50,5],ElementwiseLayer[Ramp],PoolingLayer[2,2],ConvolutionLayer[100,5],ElementwiseLayer[Ramp],PoolingLayer[4,4],FlattenLayer[]}]
sal5:=NetChain[{LinearLayer[1000],DropoutLayer[],LinearLayer[200],BatchNormalizationLayer[],ElementwiseLayer[Ramp],LinearLayer[20],BatchNormalizationLayer[],ElementwiseLayer[Ramp],LinearLayer[]}]


(* ::Input::Initialization:: *)
RED5:=NetGraph[{red5,sal5},{{NetPort["In1"]}-> 1-> 2->{NetPort["Out"]}},"In1"->"Image","Out"->{1} ]

net5=NetTrain[RED5,<|"In1"->images,"Out"->energies|>,All,MaxTrainingRounds->700,ValidationSet->Scaled[0.05],TrainingStoppingCriterion-><|"Criterion"->"Loss","Patience"->350|> ]


(* ::Input::Initialization:: *)
Export["T1plot1.png", net1["FinalPlots"]]
 {
 {Export["T1plot2.png", net2["FinalPlots"]]},
 {Export["T1plot3.png", net3["FinalPlots"]]},
 {Export["T1plot4.png", net4["FinalPlots"]]},
 {Export["T1plot5.png", net5["FinalPlots"]]}
} 
net1 = net1["TrainedNet"]
net2 = net2["TrainedNet"]
net3 = net3["TrainedNet"]
net4 = net4["TrainedNet"]
net5 = net5["TrainedNet"]
Export["T1net1.wlnet", net1]
Export["T1net2.wlnet", net2]
Export["T1net3.wlnet", net3]
Export["T1net4.wlnet", net4]
Export["T1net5.wlnet", net5]
