# Thread Safe Dictionary

# Introduction

Swift has some types that are not thread safe by default, some examples are: array and dictionary. If you want to use those structures inside an concurrenc environment, you need to create an wrapper around that deals with concurrency.

In this article, we will explore what happens if you try to use an dicitonary in a concurrent environment and how to solve the problem.

If you don`t know what is a thread or what is concurrency I recommend you reading/watching this first:

- [StackOverFlow](https://stackoverflow.com/questions/5201852/what-is-a-thread-really)
- [ByteByteGo video](https://www.youtube.com/watch?v=4rLW7zg21gI&ab_channel=ByteByteGo)

# Why it breaks?

Bellow there is a wrapper around a simple warpper around a dictionary and a code that calls it concurrently.

~~~swift
let notSafeDict = NotThreadSafeKeyValueStore()
DispatchQueue.concurrentPerform(iterations: 20) { index in
    notSafeDict.setValue("Value \(index)", forKey: "Key \(index)")
    notSafeDict.printAll()
}


class NotThreadSafeKeyValueStore {
    
    private var dict: [String: String] = [:]
    
    
    func setValue(_ value: String, forKey key: String) {
        dict[key] = value
    }
    
    func getValue(forKey key: String) -> String? {
        return dict[key]
    }
    
    func printAll() {
        print(dict)
    }
    
}
~~~

The above code give an EXEC_BAD_ACCESS error. But what that means?

That means that we have a DataRace. Data races happen when we have two or more threads trying to access the same resource and at least one of those threads is a write, that is, something that modifies a value.

In the above code we are doing exactaly that, we are starting multiple threads and asking to change the dictionary and right after we are reading all it`s content.

# Solving with the DispatchQueue way

If the code is breaking because of two threads are trying to access the same resource at the same time, what can we do to solve it? Well, we could make the threads access the resource one thread at a time. This is called serializing access.

~~~Swift 

class NotThreadSafeKeyValueStore {
    
    private var dict: [String: String] = [:]
    
    private let queue = DispatchQueue(label: "NotThreadSafeKeyValueStoreQueue")
    
    
    func setValue(_ value: String, forKey key: String) {
        queue.async { [weak self] in
            self?.dict[key] = value
        }
    }
    
    func getValue(forKey key: String) -> String? {
        return dict[key]
    }
    
    func printAll() {
        for (key, value) in dict {
            print("\(key): \(value)")
        }
    }
    
}

~~~

In the above code we create a private DispatchQueue which is serial, that is it will run all the operations one at a time. But if we try to run our code, it`s still gives the BAD_EXEC_ACCESSS error. Why is that?

Remenber that thread problems comes from writing and reading. In the above code we are synchronizing the writing, but not telling that it must serialize. We need to add the **flags: .barrier** property. 

Besides that we need to synchronize the reading to. This will enable our reading to be thread safe also.

~~~Swift 

class NotThreadSafeKeyValueStore {
    
    private var dict: [String: String] = [:]
    
    private let queue = DispatchQueue(label: "NotThreadSafeKeyValueStoreQueue")
    
    
    func setValue(_ value: String, forKey key: String) {
        queue.async(flags: .barrier) { [weak self] in
            self?.dict[key] = value
        }
    }
    
    func getValue(forKey key: String) -> String? {
        return queue.sync {
            dict[key]
        }
    }
    
    func printAll() {
        for (key, value) in dict {
            print("\(key): \(value)")
        }
    }
    
}

~~~

It's still doesn't work. That's because our printAll method is accessing the dictionary directly, because of that it needs to be synchronized to!

# Solving with Swift Concurrency

Swift Concurrency introduced a bunch of new keywords and more safety to the language. It adds a layer over threading that gives all programmers more security and confidence when wrinting concurrent code. Let`s re-write our example.

~~~Swift 
final class NotThreadSafeKeyValueStore {
    
    @MainActor
    private var dict: [String: String] = [:]
    
    @MainActor
    func setValue(_ value: String, forKey key: String) async {
        dict[key] = value
    }
    
    func getValue(forKey key: String) async -> String? {
        return await dict[key]
    }
    
    func printAll() async {
        for (key, value) in await dict {
            print("\(key): \(value)")
        }
    }
    
}

~~~

The first thing we can do is isolate our code to a global actor. That is, whenever we are inside an actor our context is serial. The @MainActor does exactly that. It isolates our mutating state to the global main actor and this will make our code serial.

A more elagant solution is o use the new **actor** object. It`s the same of class and struct, but actors deals with the synchronization for us by serializing the wrinting and synchronizing the reading.


~~~Swift 
final actor NotThreadSafeKeyValueStore {
    
    private var dict: [String: String] = [:]
    
    func setValue(_ value: String, forKey key: String) {
        dict[key] = value
    }
    
    func getValue(forKey key: String) -> String? {
        return dict[key]
    }
    
    func printAll() {
        for (key, value) in dict {
            print("\(key): \(value)")
        }
    }
    
}

~~~

# Bonus: locks

We also can use a lock. A lock is a simple structure exactly like a semaphore, it will stop the traffic (a therad) while giving permission to another thread to access the protected resource.


~~~Swift 

class NotThreadSafeKeyValueStore {
    
    private var dict: [String: String] = [:]
    
    private var lock: NSLock = NSLock()
    
    func setValue(_ value: String, forKey key: String) {
        defer { lock.unlock() }
        lock.lock()
        dict[key] = value
    }
    
    func getValue(forKey key: String) -> String? {
        return dict[key]
    }
    
    func printAll() {
        defer { lock.unlock() }
        lock.lock()
        for (key, value) in dict {
            print("\(key): \(value)")
        }
    }
    
}

~~~

# Final words and book recommendation

When dealing with threads is a good practice to know the major problems that can arise and knowing some set of tools to use if one of those problems find your code. Let me explain, when implementing a concurrent code, it can run very well and even pass all your unit tests, but are your tests runnning a million times? Can you garantee if that is the case, your code will not break? Because with threads, you don`t find problems, but the problem of a bad code will find you! 

- [Three Easy Pieces book](https://pages.cs.wisc.edu/~remzi/OSTEP/)