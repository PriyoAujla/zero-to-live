When I first started programming professionally it was in a start up and it was very chaotic and plagued by us making 
mistakes we didn't need to. All the developers were young and certainly lacked an 'old hand' 
when it came to how best resources should be provisioned (App servers, Databases etc), tooling (Which build tool we should use and why),
build pipelines. Not to mention the mistakes made in badly formed abstractions in our code base and not defining how the norms and values the team
holds for example trunk based development over branch based, always pairing or code reviews, continuous deployment over release cycles the list can go on.

I wanted to write about how you might start a website from the very beginning without making all the mistakes I and
my fellow colleagues made.


Chapter I: 'Values and Norms'

As a team/company/entity you want to decide what are your guiding principles. Why is this needed? because you need to have 
'company x way' of solving problems. This helps developers move from one code base to another relatively easily, it lets
product guys keep consistency in the user experience and it let's the company function relatively autonomously without requiring 
committees to come to a collective decision (Except when deciding what your norms and values are).

It's not necessary to come up with some exhaustive list of things that need discussing but the key here is to accept that 
a smooth running operation requires some standards and expectations to be set and also in future they have to be revisited.
Here are some things you probably should discuss when you are at a ground zero situation:

1. 'Writing code we understand is better than using xyz open source off the shelf product' - Let's look at an example, you want
to build a reporting interface for stakeholders (could be customers, internal staff etc). You can either build the system or you
could use some open source product for example Talend which could potentially 'cut down on the time spent by a dev/team'. 
This reporting interface is not going to directly allow you to sell more widgets or even give you an uplift in user registrations etc.
These are the conversations you need to have about non revenue generating activities (directly anyway).

2. 'Pair programming is something we do / pull requests FTW!' - You need to decide how collaboration is going to exist among the team
at the very coal face of building a website. Pair programming is not the only way collaboration exists, you could employ code reviews
or perhaps you trust each other so implicitly you do no checking of each other's work at all (not really recommended).

3. 'We develop products this way' - I did not want to use the word agile because it's such an often misused term. Here I want to emphasize how the company
builds something for the user, this is more than just code or features this is the whole process. It includes but not limited to discussions around 
* What is enough analysis?
* Is everything an assumption until proven not?
* Is some stuff just common sense because competitor X is doing it and we are not?
* I want stuff going live as soon as a dev is finished with it?
* Going live requires the following things to happen?

4. 'We prefer to use frameworks / don't like them at all / it depends'  - You could write you own thing in a reasonable amount of time but choose to use framework x.   
I am going to keep this brief because it's a subject that has had enough air time on the internets. 
Let me explain by use of examples what I mean by frameworks 
* Using Spring MVC because you don't want to write your own abstraction over servlets
* You want to use Ruby on rails because you don't want to choose and integrate different technologies to serve the same goal.
* You are not confident in the subject of web security and want to use Spring Security

5. 'Automation is important!' - How much do you value automation? Should that script be written first before you have ever done it manually
or should you wait until the 2nd or 3rd time you have done the same thing before automating. 
In many instances this depends on what it is you are automating, automating a bash script for some trivial thing is different 
to automating deployment of web server code and perhaps the latter should be automated before the first web server is deployed, the trivial thing
that might take 20 mins to do again if you ever have to, should be automated only if you ever have to do it again. 
You need to define where this line is.

6. 'If I make it better here it should be better like this everywhere' - Refactoring is something you will have to do and it needs to be discussed
when you should stop and just get on with the matter at hand (building that thing for the user). Sometimes refactoring a piece of of code effects all the code
straight away ie, you have just improved the API of some code and in doing so all the modules depending on it have had their code changed and all the whole code base immediately 
benefits from it. 
Other times the change will be more architectural ie, you have introduced redis to replace the use of a database because of the requirements of feature x. 
Should you then go and change the code everywhere else that could benefit from using redis and is currently using the database?