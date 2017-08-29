
Ruby/Rails debug toolkit
========================

`rails_dt` gem gives you the `DT.p()` method to print debug messages.


## Usage

In your `Gemfile`, add:

```ruby
gem "rails_dt", "git: https://github.com/dadooda/rails_dt.git"
```

Now, in your code, do something like:

```ruby
DT.p "checkpoint 1"
DT.p "user", user
```

Debug messages are printed to:

* `Rails.logger` in Rails mode (auto-detected);
* `STDERR` in non-Rails mode;
* `log/dt.log` if `log/` exists in project root and is writable.

This is often handy:

```
$ tail -f log/dt.log
```


## The ideas behind it

1. Debug message printer **must not require initialization**.
2. Debug message printer **must be nothing else**, but a debug message printer.
3. Debug message printer **must be invoked the same way** regardless of place of invocation.
4. Debug message printer calls **must be clearly visible** in code.
5. Debug message printer **must print its location in code** so you can easily remove the call once debugging is over.


### A few out-of-the-box implementations review

Let me check a few popular out-of-the box implementation used by many of developers against "the ideas" items listed above.

`Rails.logger`:

1. Fail. It only works in Rails. Rails requires initialization.
2. (!) Fail. Logger is a production facility.
3. So-so. It's not possible to use Rails logger to debug parts of Rails itself.
4. (!) Fail. Debugging logger calls look the same as production logger calls.
5. Fail. Location in code is not printed.

`Kernel::p`:

1. OK.
2. OK.
3. OK.
4. So-so. `p` calls hide well among lines of meaningful code and it isn't always easy to spot them.
5. Fail. Location in code is not printed.


## Cheers!

Feedback of any kind is greatly appreciated.

&mdash; Alex Fortuna, &copy; 2010-2017
