library(jvmr)
scala<-scalaInterpreter(unlist(strsplit(Sys.getenv("PAZUR_CLASSPATH"),":")))

interpret(scala, '
import cern.jet.random.engine.MersenneTwister
import cern.jet.random.Binomial
val mt = new MersenneTwister()
val randB = new Binomial(50,0.1,mt)',eval.only=TRUE)

> system.time(interpret(scala,'for(i<-1 to 100000000) randB.nextInt()',eval.only=TRUE))
   user  system elapsed
  6.783   0.012   6.550
> system.time(rbinom(100000000, 50, 0.1))
   user  system elapsed
  8.718   0.013   8.723
  
  
interpret(scala, '
import cern.jet.random.engine.MersenneTwister
import cern.jet.random.Normal
val mt = new MersenneTwister()
val randN = new Normal(0,1,mt)',eval.only=TRUE)  
> system.time(interpret(scala,'for(i<-1 to 100000000) randN.nextDouble()',eval.only=TRUE))
   user  system elapsed
  4.591   0.017   4.320
> system.time(rnorm(100000000,0, 1))
   user  system elapsed
  7.359   0.031   7.386

> interpret(scala,'val th = new ichi.bench.Thyme;th.pbench(for(i<-1 to 100000000) randN.nextDouble())',eval.only=TRUE,echo.output=TRUE)
Benchmark (20 calls in 84.78 s)
  Time:    4.179 s   95% CI 4.163 s - 4.194 s   (n=20)
  Garbage: 60.20 ms   (n=474 sweeps measured)

  
> library(rbenchmark)
>  benchmark(interpret(scala,'for(i<-1 to 100000000) randN.nextDouble()',eval.only=TRUE,echo.output=TRUE),replications=20)
                                                                                                 test
1 interpret(scala, "for(i<-1 to 100000000) randN.nextDouble()", eval.only = TRUE, echo.output = TRUE)
  replications elapsed relative user.self sys.self user.child sys.child
1           20  86.934        1     92.33    0.341          0         0

> 4.3467-4.179
[1] 0.1677
