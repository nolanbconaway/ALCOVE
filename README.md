#ALCOVE-MATLAB

This set of scripts runs a minimal version of the ALCOVE model of category learning (Kruschke, 1992). It is written in MATLAB, and is currently set up to simulate the six-types problem of Shepard, Hovland, & Jenkins (1961)--though it should generalize to any dataset. There are a variety of utility scripts, and a few important ones:

- **START.m** can be used to test ALCOVE using particular parameter sets.
- **ALCOVE.m** uses a provided architecture to train a network on a set of inputs and category assignments.
- **FORWARDPASS.m** and **BACKPROP.m** are used to propagate activations forward through the model, and error backward through the model, respectively. BACKPROP.m additionally completes a weight update.

Simulations are run by executing the *START.m* script. All simulations begin by passing a model struct to the *ALCOVE.m* function. At a minimum, 'model' needs to include:

| Field             | Description                               | Type                            |
| ----------------- | ------------------------------------------| :-----------------------------: |
| `referencepoints` | Training items & exemplar nodes           | Item-by-feature matrix          |
| `teachervalues`   | Network targets for each exemplar         | Item-by-category matrix [-1 +1] |
| `numblocks`       | # of passes through the training set      | Integer (>0)                    |
| `numinitials`     | # of random initial networks              | Integer (>0)                    |
| `distancemetric`  | Distance metric for exemplar nodes        | *cityblock* or *euclidean*      |
| `params`          | Network parameters (specificity, association learning, attention learning, response mapping) | Float vector (0 - Inf)|

For almost all situations, inputs and targets should be scaled to [-1 +1]. ALCOVE.m will train the network and return a result struct. As-is, 'result' contains only training accuracy for each initialization at each training block. Additional measures, such as test phase classification, can be added. You will need to write custom code to compare ALCOVE's performance to a set of behavioral data.

Written by [Nolan Conaway](http://bingweb.binghamton.edu/~nconawa1/).
Updated January 4, 2016